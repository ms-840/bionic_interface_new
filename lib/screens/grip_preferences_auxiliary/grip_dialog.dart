import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:bionic_interface/general_handler.dart';
import 'package:bionic_interface/grip_trigger_action.dart';

class GripSettingDialog extends StatefulWidget{

  final String action;
  final String currentGrip;
  final Map<String, Grip> grips;

  const GripSettingDialog({super.key,
    required this.action,
    required this.currentGrip,
    required this.grips,
  });

  @override
  State<GripSettingDialog> createState() => _GripSettingsDialog();

}

class _GripSettingsDialog extends State<GripSettingDialog>{

  late String _action;
  late String _currentGrip;
  late Map<String, Grip> _grips;

  @override
  void initState(){
    _action = widget.action;
    _currentGrip = widget.currentGrip;
    _grips = widget.grips;
  }

  void changeSelectedGrip(String newGrip){
    setState(() {
      _currentGrip = newGrip;
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
            const SizedBox(height: 5,),
            GripList(
                currentGrip: _currentGrip,
                handGrips: _grips,
                changeCurrentGrip: changeSelectedGrip),
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
                    Navigator.pop(context, _currentGrip);
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

class GripList extends StatefulWidget{
  final String currentGrip;
  final Map<String, Grip> handGrips;
  final Function(String newValue) changeCurrentGrip;


  const GripList({super.key,
    required this.currentGrip,
    required this.handGrips,
    required this.changeCurrentGrip,
  });
  @override
  State<GripList> createState() => _GripList();
}
class _GripList extends State<GripList>{

  late String _currentGrip;
  late Map<String, Grip> _handGrips;

  @override
  void initState(){
    _currentGrip = widget.currentGrip;
    _handGrips = widget.handGrips;
  }

  @override
  Widget build(BuildContext context){
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _handGrips.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index){
        String handGrip = _handGrips.keys.elementAt(index);
        return ListTile(
          title: Text(handGrip),
          selected: handGrip == _currentGrip,
          //selectedColor: Theme.of(context).cardColor,
          //tileColor: ,
          leading: Image.asset(_handGrips[handGrip]!.assetLocation, fit: BoxFit.contain, height: 120,), //this should be the relevant image
          visualDensity: const VisualDensity(horizontal: 0.0, vertical: 0.0),
          onTap: (){
            setState(() {
              widget.changeCurrentGrip(handGrip);
              _currentGrip = handGrip;
            });
          },

        );
      },
    );
  }

}