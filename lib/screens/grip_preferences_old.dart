//This page is for changing the set rules for each grip pattern
// the grip is then sent to the hand via ble

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bionic_interface/general_handler.dart';
import 'package:bionic_interface/grip_trigger_action.dart';


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
        actions: [
          const SizedBox.shrink(),
          Image.asset('assets/images/logo.png', fit: BoxFit.contain, height: 50,),
          const SizedBox(width: 10,)
        ],
      ),
      body: const Column(
        children: [
           Expanded(child: GripSettingsList()),
        ],
      ),
    );
  }
}

class GripSettingsList extends StatefulWidget{
  const GripSettingsList({super.key});

  @override
  State<GripSettingsList> createState() => _GripSettingsList();
}

class _GripSettingsList extends State<GripSettingsList>{

  @override
  void initState(){
    super.initState();
    //generalHandler = context.watch<GeneralHandler>();

    //TODO: read in data from the hand or present user settings if possible
    // Otherwise go to a default.
  }

  @override
  Widget build(BuildContext context){
    GeneralHandler generalHandler = context.watch<GeneralHandler>();
    String selectedGrip = "";
    return ListView.builder(
      itemCount: generalHandler.gripPatterns.length,
      itemBuilder: (BuildContext context, int index){
        var grips = generalHandler.gripPatterns;
        String gripName = grips.keys.elementAt(index);
        return ListTile(
          title: Row(
            children: [
              Text(gripName),
              const Expanded(child: SizedBox.shrink()),
              Text(generalHandler.currentUser.ruleForGrip(grips[gripName]!).name),
            ],
          ),
          //tileColor: ,
          leading: Image.asset(grips[gripName]!.assetLocation, fit: BoxFit.contain,), //this should be the relevant image
          //trailing: Text(generalHandler.currentUser.ruleForGrip(gripName)),//this will be the widget where you can see the selected grip pattern
          visualDensity: const VisualDensity(horizontal: 4, vertical: 4),
          selected: gripName == selectedGrip,
          selectedColor: Theme.of(context).primaryColor,
          onTap: () async{
              selectedGrip = gripName;
              var grips = generalHandler.gripPatterns;
              if(!generalHandler.userAccess[1]){ //only execute if the user does not have a child lock
                //open dialog to change this setting
                //send update command to board
                //update the users settings
                var currentRule = generalHandler.currentUser.ruleForGrip(grips[gripName]!);
                final newRule = await showDialog(
                    context: context,
                    builder: (context) => GripSettingDialog(
                        gripName: gripName,
                        currentRule: currentRule.name,
                        gripRules: generalHandler.triggers
                    )
                );
                if(newRule!=null &&
                    newRule != currentRule){
                    generalHandler.updateGripSettingsBle(gripName, newRule); //This should actually be awaited
                    var rules = generalHandler.triggers;
                    setState(() {
                      generalHandler.currentUser.updateGripSettings(grips[gripName]!, rules[newRule]!);
                    });
                }
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
  final Map<String, Trigger> gripRules;

  const GripSettingDialog({super.key,
    required this.gripName,
    required this.currentRule,
    required this.gripRules,
  });

  @override
  State<GripSettingDialog> createState() => _GripSettingsDialog();

}

class _GripSettingsDialog extends State<GripSettingDialog>{

  late String _gripName;
  late String _currentRule;
  late Map<String, Trigger> _gripRules;

  @override
  void initState(){
    _gripName = widget.gripName;
    _currentRule = widget.currentRule;
    _gripRules = widget.gripRules;
  }

  void changeSelectedRule(String newRule){
    setState(() {
      _currentRule = newRule;
    });
  }

  @override
  Widget build(BuildContext context){
    var grips = context.watch<GeneralHandler>().gripPatterns;
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row( //Row with picture and name of grip
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(grips[_gripName]!.assetLocation, fit: BoxFit.contain, height: 120,),
                ),
                //const Expanded(child: SizedBox.shrink()),
                Text(_gripName,),
              ],
            ),
            const SizedBox(height: 5,),
            GripRulesList(
                currentRule: _currentRule,
                gripRules: _gripRules,
                changeCurrentRule: changeSelectedRule),
            const SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                ),
                const SizedBox(width: 5,),
                ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context, _currentRule);
                  }, //return the new setting
                  child: const Text("OK"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class GripRulesList extends StatefulWidget{

  final String currentRule;
  final Map<String, Trigger> gripRules;
  final Function(String newValue) changeCurrentRule;


  const GripRulesList({super.key,
    required this.currentRule,
    required this.gripRules,
    required this.changeCurrentRule,
  });

  @override
  State<GripRulesList> createState() => _GripRulesList();
}

class _GripRulesList extends State<GripRulesList>{

  late String _currentRule;
  late Map<String, Trigger> _gripRules;

  @override
  void initState(){
    _currentRule = widget.currentRule;
    _gripRules = widget.gripRules;
  }

  @override
  Widget build(BuildContext context){
    return ListView.builder(
      itemCount: _gripRules.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index){
        String gripRule = _gripRules.keys.elementAt(index);
        return ListTile(
          title: Text(gripRule),
          selected: gripRule == _currentRule,
          //selectedColor: Theme.of(context).cardColor,
          //tileColor: ,
          leading: const Text("image?"), //this should be the relevant image
          visualDensity: const VisualDensity(horizontal: 0.0, vertical: 0.0),
          onTap: (){
            setState(() {
              widget.changeCurrentRule(gripRule);
              _currentRule = gripRule;
            });
          },

        );
      },
    );
  }
}