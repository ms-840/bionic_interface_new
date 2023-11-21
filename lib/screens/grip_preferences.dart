//This page is for changing the set rules for each grip pattern
// the grip is then sent to the hand via ble

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bionic_interface/general_handler.dart';


class GripSettings extends StatelessWidget{
  const GripSettings({super.key});

  /*
  this page should contain:
    - list tiles of the grips available (and current settings)
    - when clicked, allow the changing of the of the grip pattern/remove any rules

    Ideally the settings it opens up on could be read from the current settings in the hand itself or from a user profile

   */


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rebel Bionics"),
        actions: [],
      ),
      body: Expanded(child: GripSettingsList()),
    );
  }


}

class GripSettingsList extends StatefulWidget{
  @override
  State<GripSettingsList> createState() => _GripSettingsList();
}

class _GripSettingsList extends State<GripSettingsList>{
  
  late GeneralHandler generalHandler;
  
  @override
  void initState(){
    super.initState();
    generalHandler = context.watch<GeneralHandler>();

    //TODO: read in data from the hand or present user settings if possible
    // Otherwise go to a default.
  }

  @override
  Widget build(BuildContext context){
    return ListView.builder(
      itemCount: generalHandler.gripPatterns.length,
      itemBuilder: (BuildContext context, int index){
        String gripName = generalHandler.gripPatterns.keys.elementAt(index);
        return ListTile(
          title: Text(gripName),
          //tileColor: ,
          leading: const Text("image to come"), //this should be the relevant image
          trailing: const Text("rule indicator to come"),//this will be the widget where you can see the selected grip pattern
          visualDensity: const VisualDensity(horizontal: 0.0, vertical: 0.0),
          onTap: (){
              if(!generalHandler.userAccess[1]){ //only execute if the user does not have a child lock
                //open dialog to change this setting
                //send update command to board
                //update the users settings
              }
          },
        );
      },
    );
  }
}

class GripSettingDialog extends StatefulWidget{

  final String gripName;
  final String currentRule;
  final Map<String, int> gripRules;

  GripSettingDialog({super.key,
    required this.gripName,
    required this.currentRule,
    required this.gripRules,
  })

  @override
  State<GripSettingDialog> createState() => _GripSettingsDialog();
}

class _GripSettingsDialog extends State<GripSettingDialog>{

  late String _gripName;
  late String _currentRule;
  late Map<String, int> _gripRules;

  @override
  void initState(){
    _gripName = widget.gripName;
    _currentRule = widget.currentRule;
    _gripRules = widget.gripRules;
  }
  //todo: fill this out
  @override
  Widget build(BuildContext context){
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(), //Row with picture and name of grip
              const SizedBox(height: 5,),
              Expanded(child: child), //this needs to be another list view with grip rules
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: (){},
                      child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 5,),
                  ElevatedButton(
                    onPressed: (){}, //return the new setting
                    child: const Text("OK"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}