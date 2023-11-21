import 'package:flutter/material.dart';
//TODO: change this to a different screen
// it should allow you to select and connect to a nearby hand and prompt you where to go?
// maybe have ble connection be a thing that happens before, also need something to log in

class HomePage extends StatelessWidget{
  const HomePage({super.key});


  /*
  elements on this page:
    - show ble connection status (possibly in a corner?)
    - put up a pop up to connect to the correct device
    - navigate to other sections (only sections visible according to access)
   */



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rebel Bionics"),
        actions: [],
      ),
      body: const Text("There is nothing here yet"),
    );
  }


}