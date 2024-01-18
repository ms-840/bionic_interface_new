import 'package:bionic_interface/general_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: (){
                //This should open a pop up to see the nearby BLE device
              },
              child: const Text("BLE Status")),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: (){
                    //Todo this should only be available when connected + permissions are right
                    Navigator.popAndPushNamed(context, "/grip");
                  },
                  child: const Text("To Settings"),
              ),
              ElevatedButton(
                onPressed: (){
                  //Todo this should only be available when connected + permissions are right
                  Navigator.popAndPushNamed(context, "/plot");
                },
                child: const Text("To Plot"),
              ),
            ],
          ),
        ],
      ),

    );
  }


}