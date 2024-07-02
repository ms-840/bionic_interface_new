import 'package:bionic_interface/general_handler.dart';
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
        print('User is currently signed out!');
        _loggedIn = false;
      } else {
        print('User is signed in!');
        _loggedIn = true;
        //Todo: sync data from db - or give the user the choice to sync settings from the db?
      }
      notifyListeners();
    });
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

  /// takes a user object and uses the data to update the online database
  ///
  Future<void> updateHandActions(RebelUser user){
    if(!_loggedIn){
      throw Exception('Must be logged in to update User Details');
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
      //'advancedSetting' : , //TODO: figure out a good way to turn this into an object for firestore
      //'signalSettings' : , //TODO: figure out a good way to turn this into an object for firestore
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
  Future<void> syncWithOnlineDatabase(BuildContext context) async{
    if(!_loggedIn){
      throw Exception('Must be logged in to update User Details');
    }
    var generalHandler = Provider.of<GeneralHandler>(context, listen: false);
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
          newDirectActions: actionSettings['directActions'],
          newSignalSettings: handSettings['signalSettings'],
          newAdvancedSettings: handSettings['advancedSettings']);
    }
    else{
      print("One or more fields were not present in your online profile, please contact us");
    }

  }




  //TODO: in order:
  // 1. test that the login and such works as it should <- IT DOES BUT THE PAGES NEED BETTER ROUTING
  // 1.5 create a page that i can use to test the firebase Handler functions <- done, its the test page, just needs some more of the thinfs
  // 2. ensure creating the objects works as it should
  // 3. create functions to convert data from firebase to update user data
  // 4. consider if there is a way to make the updates + downloads more data plan friendly?

  //#endregion
}