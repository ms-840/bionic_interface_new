import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/data_plot.dart';
import 'screens/grip_preferences_old.dart';
import 'screens/grip_preferences.dart';
import 'screens/hand_calibration.dart';
import 'screens/new_user.dart';



class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/plot':
        return MaterialPageRoute(builder: (_) => const DataPresentationPage());
      case '/grip':
        return MaterialPageRoute(builder: (_) => const GripSettings2());
      case '/calibration':
        return MaterialPageRoute(builder: (_) => const HandCalibration());
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