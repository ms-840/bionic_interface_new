import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:bionic_interface/general_handler.dart';
import 'package:bionic_interface/grip_trigger_action.dart';

class TriggerSettingDialog extends StatefulWidget{

  final String action;
  final String currentTrigger;
  final Map<String, Trigger> gripTriggers;

  const TriggerSettingDialog({super.key,
    required this.action,
    required this.currentTrigger,
    required this.gripTriggers,
  });

  @override
  State<TriggerSettingDialog> createState() => _TriggerSettingsDialog();

}

class _TriggerSettingsDialog extends State<TriggerSettingDialog>{

  late String _action;
  late String _currentTrigger;
  late Map<String, Trigger> _gripTriggers;

  @override
  void initState(){
    super.initState();
    _action = widget.action;
    _currentTrigger = widget.currentTrigger;
    _gripTriggers = widget.gripTriggers;
  }

  void changeSelectedTrigger(String newTrigger){
    setState(() {
      _currentTrigger = newTrigger;
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
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 5,),
                  TriggersList(
                      currentTrigger: _currentTrigger,
                      gripTriggers: _gripTriggers,
                      changeCurrentTrigger: changeSelectedTrigger),
                  const SizedBox(height: 5,),
                ],
              ),
            ),
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
                    Navigator.pop(context, _currentTrigger);
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

class TriggersList extends StatefulWidget{

  final String currentTrigger;
  final Map<String, Trigger> gripTriggers;
  final Function(String newValue) changeCurrentTrigger;


  const TriggersList({super.key,
    required this.currentTrigger,
    required this.gripTriggers,
    required this.changeCurrentTrigger,
  });

  @override
  State<TriggersList> createState() => _TriggersList();
}

class _TriggersList extends State<TriggersList>{

  late String _currentTrigger;
  late Map<String, Trigger> _gripTriggers;

  @override
  void initState(){
    super.initState();
    _currentTrigger = widget.currentTrigger;
    _gripTriggers = widget.gripTriggers;
  }

  //TODO: ideally this should point out what it is currently used for? and maybe not let you set it? or remove the binding to the other
  @override
  Widget build(BuildContext context){
    return ListView.builder(
      itemCount: _gripTriggers.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index){
        String gripTrigger = _gripTriggers.keys.elementAt(index);
        return ListTile(
          title: Text(gripTrigger),
          selected: gripTrigger == _currentTrigger,
          //selectedColor: Theme.of(context).cardColor,
          //tileColor: ,
          // leading: const Text("image?"), //this should be the relevant image
          visualDensity: const VisualDensity(horizontal: 0.0, vertical: 0.0),
          onTap: (){
            setState(() {
              widget.changeCurrentTrigger(gripTrigger);
              _currentTrigger = gripTrigger;
            });
          },

        );
      },
    );
  }
}