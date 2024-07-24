import 'package:bionic_interface/data_handling/ble_interface.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:bionic_interface/general_handler.dart';
import 'package:bionic_interface/grip_trigger_action.dart';
import 'grip_dialog.dart';
import 'trigger_dialog.dart';
import 'package:go_router/go_router.dart';

/// This describes a screen that can be used by the user to select a specific grip for the hand to use.
///
/// The screen contains cards with each grip that can be selected.
///
class GripSelector extends StatefulWidget{
  const GripSelector({super.key});


  @override
  State<GripSelector> createState() => _GripSelectorState();
}


class _GripSelectorState extends State<GripSelector>{

  /// If not null, this active string is the active grip name
  /// TODO: figure out what the reprercussions are for the hand usage and how long the active grip persists
  String? activeGrip;

  @override
  Widget build(BuildContext context) {
    var generalHandler = Provider.of<GeneralHandler>(context, listen: false);
    var bleHandler = Provider.of<BleInterface>(context, listen: false);
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: OrientationBuilder(
          builder: (context, orientation){
            return GridView.count(
              physics: const ScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: orientation == Orientation.portrait ? 2:3, //TODO: THIS SHOULD AUTOMATICALLY FILL THE SPACE IT HAS, ie if there is more horizontal space, turn to 3 or 4
              children: <Widget>[
                for(var grip in generalHandler.onlyGripPatterns.values)
                  ListTile(
                      selected: activeGrip==grip.name,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: activeGrip==grip.name?
                        Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.background,
                            width: 5),
                        borderRadius: BorderRadius.circular(60),
                      ),
                      onTap: (){
                        if(activeGrip==grip.name){
                          activeGrip = null;
                          //TODO: BLE COMMAND
                        }
                        else{
                          activeGrip = grip.name;
                          //TODO: BLE COMMAND
                        }
                        setState(() {});
                      },
                      title: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(grip.assetLocation),
                            Text(grip.name, style: TextStyle(color: activeGrip==grip.name?
                            Theme.of(context).colorScheme.secondary : Colors.black,)),
                          ],
                        ),
                      )
                  ),
              ],
            );
          }
        ),
    );

  }


}

