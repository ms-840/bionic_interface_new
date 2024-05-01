import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// This file (and contained class) should hold and deal with any communications with firebase
///including:
/// - initializing Firebase connection
/// - authenticating users
/// - communicating with firebase database
/// - persisting data on the phone between use sessions
///     see https://stackoverflow.com/questions/51288944/is-there-a-way-for-firebase-flutter-apps-to-persist-data-across-offline-app-rest for general persistance
///
class FirebaseHandler extends ChangeNotifier{


  Future<void> initializeFirebase() async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  //#region Authorization and User management

  ///A bool to indicate if a user is signed in
  /// - true: a user is signed into the firebase account
  /// - false: no user is signed in
  bool authStatus = false;

  /// an instance of the current user?
  /// my current idea is that at the very least it can define if
  /// the user is currently null or not
  /// NOT SURE IF THIS IS USEFUL YET
  User? currentUser;


  /// starts a stream that checks authorization status
  void initializeAuthStatus() {
    //note that on native platforms (ie not web) firebase automatically persists authentication states

    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
          currentUser = user;
      if (user == null) {
        print('User is currently signed out!');
        authStatus = false;
      } else {
        print('User is signed in!');
        authStatus = true;
      }
    });
  }

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
  void linkAuthProvicersToUser(){
    //todo: still needs to be made
  }

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

  //#endregion

  //#region Firebase Database
  ///should contain methods for updating the database with set values
  /// or getting new updates from the database
  //#endregion
}