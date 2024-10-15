import 'package:bionic_interface/general_handler.dart';
import 'package:bionic_interface/main.dart';
import 'package:bionic_interface/user/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This file (and contained class) should hold and deal with any communications with firebase
///including:
/// - initializing Firebase connection
/// - authenticating users
/// - communicating with firebase database
/// - persisting data on the phone between use sessions
///     see https://stackoverflow.com/questions/51288944/is-there-a-way-for-firebase-flutter-apps-to-persist-data-across-offline-app-rest for general persistance
///
class FirebaseHandler extends ChangeNotifier{

  FirebaseHandler(){
    print("starting Firebase initialization");
    init();
  }

  Future<void> init() async{
    await initializeFirebase();
    initializeAuthStatus();
    //Provider.of<FirebaseHandler>(context, listen: false).setupNewUser(Provider.of<GeneralHandler>(context, listen:false).currentUser); //TODO: move this to when a user is created
  }

  Future<void> initializeFirebase() async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);
    print("Firebase initialized");
    //If there was something that should always be subscribed to,
    // here would be where to put it
  }

  //#region Authorization and User management

  ///A bool to indicate if a user is signed in
  /// - true: a user is signed into the firebase account
  /// - false: no user is signed in
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  /// an instance of the current user?
  /// my current idea is that at the very least it can define if
  /// the user is currently null or not
  /// NOT SURE IF THIS IS USEFUL YET
  User? currentUser;


  /// starts a stream that checks authorization status
  void initializeAuthStatus() {
    //note that on native platforms (ie not web) firebase automatically persists authentication states
    //ie i dont need to do anything to make it persist
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
          currentUser = user;

      if (user == null) {
        _loggedIn = false;
      } else {
        _loggedIn = true;
        syncWithOnlineDatabase();

        //Todo: sync data from db - or give the user the choice to sync settings from the db?
      }
      notifyListeners();
    });
  }

  ///Sets up a user object according to the settings saved in firestore
  void syncUserData() async{
    //things to sync:
    // - hand settings (which is the up to date user specific one, not the saved ones)
    // - action settings (the hand actions set in the app)

    final handSettings = await FirebaseFirestore.instance
        .collection('handSettings').doc(FirebaseAuth.instance.currentUser!.uid).get();

    final actionSettings = await FirebaseFirestore.instance
        .collection('actionSettings').doc(FirebaseAuth.instance.currentUser!.uid).get();

    RebelUser user = RebelUser.fromDb(
        accessType: "editor",
        newCombinedActions: actionSettings["combinedActions"],
        newOpposedActions: actionSettings["opposedActions"],
        newUnopposedActions: actionSettings["unopposedActions"],
        newDirectActions: actionSettings["directActions"],
        advancedSettings: handSettings["advancedSettings"],
        signalSettings: handSettings["signalSettings"]
    );

    final generalHandler = navigatorKey.currentContext!.watch<GeneralHandler>();
    generalHandler.currentUser = user;
    //set the general handler


  }

  void setupNewUser(RebelUser user){
    updateHandSettings(user);
    updateHandActions(user);
  }



  ///NOTE: THIS IS UNUSED. logging in is handled by the sign in screen
  /// create new Firebase User using an email + password combination
  /// if the password is too weak or the email is already in use,
  /// firebase will return an error code.
  /// If the user is successfully made, it is also immediatly logged in
  /// see https://firebase.google.com/docs/auth/flutter/password-auth for documentation
  void newUserEmail(String emailAddress, String password) async{
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.'); //TODO: add better error handling
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.'); //TODO: add better error handling
      }
    } catch (e) {
      print(e);
    }
  }

  ///should be used to link auth provides - not super useful at the moment but
  ///could be used to connect eg google signins to an email login user
  ///see https://firebase.google.com/docs/auth/flutter/account-linking
  void linkAuthProvidersToUser(){
    //todo: still needs to be made
  }

  ///NOTE: THIS IS UNUSED. logging in is handled by the sign in screen
  ///signs the user in using email and password
  void loginEmailPassword(String emailAddress, String password) async{
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.'); //TODO: add better error handling
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.'); //TODO: add better error handling,
        //TODO: also the user should not be told that the password is wrong
      }
    }
  }

  /* // this bit is commented out for now, it would be best to first make sure i can get it to work properly
  /// sends the user a link with which they can log into the app
  /// see https://firebase.google.com/docs/auth/flutter/email-link-auth
  /// Benefit is that the users dont need passwords
  ///
  /// TODO: note that all of this is still the default, still needs to be changed so it actually works with Rebel things
  void loginEmailLink(String emailAddress){

    // 1. setup the action code setting object
    var acs = ActionCodeSettings(
      // URL you want to redirect back to. The domain (www.example.com) for this
      // URL must be whitelisted in the Firebase Console.
        url: 'https://www.example.com/finishSignUp?cartId=1234', //this is where the user will be redirected back to if they dont have the app installed
        // This must be true
        handleCodeInApp: true,
        iOSBundleId: 'com.example.ios',
        androidPackageName: 'com.example.android',
        // installIfNotAvailable
        androidInstallApp: true,
        // minimumVersion
        androidMinimumVersion: '12');

    // 2. send the login request email
    FirebaseAuth.instance.sendSignInLinkToEmail(
        email: emailAddress, actionCodeSettings: acs)
        .catchError((onError) => print('Error sending email verification $onError'))
        .then((value) => print('Successfully sent email verification'));

    // 3. Confirm the link is a sign-in with email link. //TODO: THIS IS BECOMING DEPRECATED< NEED TO LOOK AT ALTERNATIVES?
    //TODO: see https://firebase.google.com/support/dynamic-links-faq
    if (FirebaseAuth.instance.isSignInWithEmailLink(emailLink)) {
      try {
        // The client SDK will parse the code from the link for you.
        final userCredential = await FirebaseAuth.instance
            .signInWithEmailLink(email: emailAuth, emailLink: emailLink);

        // You can access the new user via userCredential.user.
        final emailAddress = userCredential.user?.email;

        print('Successfully signed in with email link!');
      } catch (error) {
        print('Error signing in with email link.');
      }
    }
  }
   */
  //#endregion

  //#region Firebase Database
  ///should contain methods for updating the database with set values
  /// or getting new updates from the database

  Future<void> updateUserDetails({String name = "", }){
    if(!_loggedIn){
      throw Exception('Must be logged in to update User Details');
    }
    return FirebaseFirestore.instance
        .collection('userDetails').doc(FirebaseAuth.instance.currentUser!.uid)
        .set(<String, dynamic>{
      'name': name,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  //#region Hand Actions and Settings
  /// takes a user object and uses the data to update the online database
  ///
  Future<void>? updateHandActions(RebelUser user){
    if(!_loggedIn){
      print("User Details Not updated");
      return null;
    }
    return FirebaseFirestore.instance
        .collection('actionSettings').doc(FirebaseAuth.instance.currentUser!.uid)
        .set(<String, dynamic>{
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'lastUpdated' : DateTime.timestamp(),
      'combinedActions': user.combinedActionAsString,
      'opposedActions': user.opposedActionAsString,
      'unopposedActions': user.unopposedActionAsString,
      'directActions' : user.directActionAsString,
    });
  }

  Future<void> updateHandSettings(RebelUser user){
    if(!_loggedIn){
      throw Exception('Must be logged in to update User Details');
    }
    return FirebaseFirestore.instance
        .collection('handSettings').doc(FirebaseAuth.instance.currentUser!.uid)
        .set(<String, dynamic>{
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'lastUpdated' : DateTime.timestamp(),
      'advancedSettings' : user.advancedSettings.toString(),
      'signalSettings' : user.signalSettings.toString(),
    });
  }

  dynamic getHandSettings(){
    if(!_loggedIn){
      throw Exception('Must be logged in to update User Details');
    }
    return FirebaseFirestore.instance
        .collection('actionSettings')
        .doc(FirebaseAuth.instance.currentUser!.uid).get();
  }

  /// This retrieves the data from the database and updates the hand actions and hand settings
  Future<void> syncWithOnlineDatabase() async{
    if(!_loggedIn){
      throw Exception('Must be logged in to update User Details');
    }
    final context = navigatorKey.currentContext!;
    var generalHandler = Provider.of<GeneralHandler>(context, listen: false);
    print(FirebaseAuth.instance.currentUser!.uid);
    final handSettings = await FirebaseFirestore.instance
        .collection('handSettings')
        .doc(FirebaseAuth.instance.currentUser!.uid).get();
    final actionSettings = await FirebaseFirestore.instance
        .collection('actionSettings')
        .doc(FirebaseAuth.instance.currentUser!.uid).get();

    if(handSettings.exists && actionSettings.exists){
      generalHandler.currentUser.setAllSettings(generalHandler,
          newOpposedActions: actionSettings['opposedActions'],
          newUnopposedActions: actionSettings['unopposedActions'],
          newCombinedActions: actionSettings['combinedActions'],
          newDirectActions: actionSettings['directActions'],
          newSignalSettings: handSettings['signalSettings'],
          newAdvancedSettings: handSettings['advancedSettings']);

      print("user data synced");
    }
    else{
      print("One or more fields were not present in your online profile, please contact us");
    }
  }
  //#endregion

  //#region Configs

  ///Gets all available configs set in the database
  /// Arguments
  /// - String: handID
  ///
  /// Returns
  /// - Firebase collection
  dynamic getHandConfigs(String handID) async {

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('handConfigurations')
        .doc(handID).collection('savedConfigs').get();

    final queryList = querySnapshot.docs.map((doc) => doc).toList();
    if(queryList.isEmpty){
      await createInitialConfig(handID);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('handConfigurations')
          .doc(handID).collection('savedConfigs').get();
    }
    return querySnapshot.docs.map((doc) => doc).toList();
  }

  /// Creates the config file for a Hand if it does not already exist
  /// Arguments
  /// - String: [handID]
  dynamic createInitialConfig(String handID) async{
    final context = navigatorKey.currentContext!;
    final generalHandler = Provider.of<GeneralHandler>(context, listen: false);
    var docID = "";
    await FirebaseFirestore.instance
        .collection("handConfigurations").doc(handID)
        .collection("savedConfigs").add(<String, dynamic>{
      "userID" : FirebaseAuth.instance.currentUser!.uid,
      "config" : generalHandler.currentUser.configToJSON(),
      "configName" : "Initial Config",
      "clinician" : true,
      "dateSaved" : DateTime.timestamp(),
    }).then((DocumentReference doc) => {docID = doc.id});
    await FirebaseFirestore.instance
        .collection("handConfigurations").doc(handID).set(<String, dynamic>{
      "name" : "Rebel Bionics Hand",
      "active" : docID
    }
    );
  }


  ///Updates the name of a config saved by the current user
  /// Arguments
  /// - String: [handID]
  /// - String: [configID]
  /// - String: [newName]
  ///
  /// Returns
  /// - Void
  Future<void> updateConfigName(
      String handID, String configID, String newName) async{
    if(!_loggedIn){
      throw Exception('Must be logged in to update User Details');
    }
    final config = FirebaseFirestore.instance
        .collection("handConfigurations").doc(handID)
        .collection("savedConfigs").doc(configID);
    final checkIfConfigExists = await config.get();
    if(checkIfConfigExists.exists){
      await config.update(<String, dynamic>{'configName': newName});
    }
  }

  ///Save new config to firebase
  /// Arguments
  /// - String: handID
  /// - String: configJSON
  /// - String: configName
  ///
  /// Returns
  /// - void
  Future<String> saveNewConfig(
      String handID,
      String configJSON,
      String configName,
      ) async{
    if(!_loggedIn){
      throw Exception('Must be logged in to update User Details');
    }
    String docID = "";
    await FirebaseFirestore.instance
        .collection("handConfigurations").doc(handID)
        .collection("savedConfigs").add(<String, dynamic>{
          "userID" : FirebaseAuth.instance.currentUser!.uid,
          "config" : configJSON,
          "configName" : configName,
          "clinician" : false,
          "dateSaved" : DateTime.timestamp(),
    }).then((DocumentReference doc) => {docID = doc.id});
    return docID;
  }

  /// Updates the firebase device collection
  Future<void> setActiveConfig(String handID, String configId){
    return FirebaseFirestore.instance
        .collection("handConfigurations").doc(handID).update(<String, dynamic>{
          "active" : configId,
    });
  }

  ///Returns the id of the config noted to be active
  Future<dynamic> getActiveConfigID(String handID) async{
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('handConfigurations')
        .doc(handID).get();
    if(documentSnapshot.exists){
      return documentSnapshot["active"];
    }
    else{
      return Null;
    }
  }


  Future<void> deleteConfig(String handID, String configID) async{
    if(!_loggedIn){
      throw Exception('Must be logged in to update User Details');
    }
     await FirebaseFirestore.instance
        .collection('handConfigurations')
        .doc(handID).collection("savedConfigs").doc(configID).delete();
  }

  //#endregion

  //#region Hand Names
  Future<void> setHandName(String handID, String newName) async{
    await FirebaseFirestore.instance
        .collection("handConfigurations").doc(handID).update(<String, dynamic>{
        "name" : newName,
           });
    notifyListeners();
  }

  Future<String> getHandName(String handID) async{
    final query = await FirebaseFirestore.instance
        .collection("handConfigurations").doc(handID).get();
    if (query.exists){
      return query.data()!["name"];
    }
    else{
      return "";
    }
  }

  //#endregion

  //#endregion
}