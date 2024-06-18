import 'package:bionic_interface/screens/select_user.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/data_plot.dart';
import 'screens/grip_preferences.dart';
import 'screens/hand_calibration.dart';
import 'screens/new_user.dart';
import 'screens/ble_status.dart';
import 'package:go_router/go_router.dart';



class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/plot':
        return MaterialPageRoute(builder: (_) => const DataPresentationPage());
      case '/grip':
        return MaterialPageRoute(builder: (_) => const GripSettings());
      case '/calibration':
        return MaterialPageRoute(builder: (_) => const HandCalibration());
      case '/ble':
        return MaterialPageRoute(builder: (_) => const BleStatusPage());
      case '/newUser':
        return MaterialPageRoute(builder: (_) => const NewUserPage());
      case '/selectAccount':
        return MaterialPageRoute(builder: (_) => const SelectUser());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_){
      return Scaffold(
        appBar: AppBar(
          title: const Text('No Route'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('No route found'),
        ),
      );
    });
  }
}

final router = GoRouter(
  routes: [
    GoRoute(
        path: '/', //Default, homescreen
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
              path: 'sign-in',
              builder: (context, state){
                return SignInScreen(
                  actions: [
                    ForgotPasswordAction((context, email) {
                      //This is taken from the codelab
                      final uri = Uri(
                        path: '/sign-in/forgot-password',
                        queryParameters: <String, String?>{
                          'email': email,
                        },
                      );
                      context.push(uri.toString());
                    }),
                    AuthStateChangeAction(((context, state) {
                      final user = switch (state) {
                        SignedIn state => state.user,
                        UserCreated state => state.credential.user,
                        _ => null
                      };
                      if (user == null) {
                        return;
                      }
                      if (state is UserCreated) {
                        user.updateDisplayName(user.email!.split('@')[0]);
                      }
                      if (!user.emailVerified) {
                        user.sendEmailVerification();
                        const snackBar = SnackBar(
                            content: Text(
                                'Please check your email to verify your email address'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      context.pushReplacement('/');
                    })),
                  ],
                );
              },
              routes: [
                GoRoute(
                  path: 'forgot-password',
                  builder: (context, state) {
                    final arguments = state.uri.queryParameters;
                    return ForgotPasswordScreen(
                      email: arguments['email'],
                      headerMaxExtent: 200,
                    );
                  },
                ),
              ],
          ), //Sign in screen
        ],
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) {
        return ProfileScreen(
          providers: const [],
          actions: [
            SignedOutAction((context) {
              context.pushReplacement('/');
            }),
          ],
        );
      },
    ), //Profile screen
    GoRoute(
      path: '/plot',
      builder: (context, state) => const DataPresentationPage(),
      routes: [
        GoRoute(
            path: 'calibration',
          builder: (context, state) => const HandCalibration(),
        ),
      ]
    ), //Data Presentation Page
    GoRoute(
      path: '/grip',
      builder: (context, state) => const GripSettings(),
    ), //Grip settings
    GoRoute(
      path: '/calibration',
      builder: (context, state) => const HandCalibration(),
    ), // Hand Calibration
    GoRoute(
      path: '/ble',
      builder: (context, state) => const BleStatusPage(),
    ),
  ]
);