import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'route_generator.dart';

import 'data_handling/ble_interface.dart';
import 'data_handling/data_handler.dart';
import 'screens/home.dart';
import 'general_handler.dart';

void main() {
  runApp(const MainApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BleInterface(),),
        ChangeNotifierProvider(create: (context) => DataHandler(Provider.of<BleInterface>(context, listen: false))),
        ChangeNotifierProvider(create: (context) => GeneralHandler(Provider.of<BleInterface>(context, listen: false))),
      ],
      child: MaterialApp(
        title: 'Bionic Interface',
        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        initialRoute: '/home',
        onGenerateRoute: RouteGenerator.generateRoute,
        navigatorKey: navigatorKey,
        home: const HomePage(),
      ),
    );
  }
}


