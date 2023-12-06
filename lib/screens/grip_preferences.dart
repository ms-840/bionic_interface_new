import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:bionic_interface/general_handler.dart';
import 'package:bionic_interface/grip_trigger_action.dart';


class GripSettings2 extends StatelessWidget{
  const GripSettings2({super.key});

  @override
  Widget build(BuildContext context) {
    var generalHandler = context.watch<GeneralHandler>();
    return Scaffold(
      appBar: AppBar(

        title: const Text("Rebel Bionics"),
        actions: [
          const SizedBox.shrink(),
          Image.asset('assets/images/logo.png', fit: BoxFit.contain, height: 50,),
          const SizedBox(width: 10,)
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ThumbTapSwitch(),
          //cycle trigger selector
          const CycleTriggerSelector(),
          const SizedBox(height: 10),
          Expanded(child: generalHandler.useThumbToggling?
               const DoubleTypeList()
              : const SingleTypeList()
          ),

        ],
      ),
    );
  }

}

class ThumbTapSwitch extends StatefulWidget{
  const ThumbTapSwitch({super.key});

  @override
  State<ThumbTapSwitch> createState() => _ThumbTapSwitchState();
}
class _ThumbTapSwitchState extends State<ThumbTapSwitch>{
  final MaterialStateProperty<Icon?> thumbIcon =
  MaterialStateProperty.resolveWith<Icon?>(
        (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  Widget build(BuildContext context){
    var generalHandler = context.watch<GeneralHandler>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          const Text("Use thumb tap toggling"),
          const Spacer(),
          Switch(
            thumbIcon: thumbIcon,
            value: generalHandler.useThumbToggling,
            onChanged: (bool value) {
              setState(() {
                generalHandler.toggleThumbTapUse();
              });
            },
          ),
        ],
      ),
    );
  }

}

class CycleTriggerSelector extends StatelessWidget{
  const CycleTriggerSelector({super.key});

  @override
  Widget build(BuildContext context){
    var generalHandler = context.watch<GeneralHandler>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          const Text("Next Grip Trigger"),
          const Spacer(),
          ElevatedButton(
              onPressed: () async{
                if(!generalHandler.userAccess[1]){
                 var currentTrigger = generalHandler.currentUser.triggerForAction("Next Grip")!;
                 var triggers = generalHandler.triggers;
                 final newTrigger = await showDialog(
                     context: context,
                     builder: (context) => TriggerSettingDialog(
                         action: "Next Grip",
                         currentTrigger: currentTrigger.name,
                         gripTriggers: triggers));
                 if(newTrigger!=null && newTrigger!= currentTrigger){
                    //Todo: send the update to the hand
                   var newTriggerItem = generalHandler.triggers[newTrigger]!;
                   generalHandler.updateAction("Next Grip", null, newTriggerItem);
                 }
                }
              },
              child: Text(generalHandler.currentUser.triggerForAction("Next Grip").name),
          )
        ],
      ),
    );
  }

}

class SingleTypeList extends StatelessWidget{
  const SingleTypeList({super.key});

  @override
  Widget build (BuildContext context){
    return const ReorderableGripList(listType: "Combined");
  }
}

class DoubleTypeList extends StatelessWidget{
  const DoubleTypeList({super.key});

  @override
  Widget build (BuildContext context){
    //TODO: this should be more like a list view thing
    return const DefaultTabController(
        length: 2,
        child:  Column(
          children: [
             TabBar(
                tabs: [
                  Text("Opposed"),
                  Text("Unopposed"),
                ],
            ),
            Expanded(
              child: TabBarView(
                  children: [
                    ReorderableGripList(listType: "Opposed"),
                    ReorderableGripList(listType: "Unopposed"),
                  ],
              ),
            ),
          ],
        ));
  }
}


class ReorderableGripList extends StatefulWidget{
  //this also needs what list it should display
  final String listType; //this is used to figure out what map needs to be used (ie opposed, unopposed, combined)
  const ReorderableGripList({super.key, required this.listType});

  @override
  State<ReorderableGripList> createState() => _ReorderableGripListState();
}

class _ReorderableGripListState extends State<ReorderableGripList>{
  // if the list view is the last one, it should have a plus and when pressed add another entry
  late String _listType;
  late Map<String, HandAction> _gripList;
  late Map<String, Grip> allGrips;
  late List<HandAction>_items;
  late List<String> _actionTitles;


  @override
  void initState(){
    _listType = widget.listType;
  }

  @override
  Widget build(BuildContext context){

    Widget proxyDecorator(
        Widget child, int index, Animation<double> animation) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final double animValue = Curves.easeInOut.transform(animation.value);
          final double elevation = lerpDouble(0, 6, animValue)!;
          return Material(
            elevation: elevation,

            child: child,
          );
        },
        child: child,
      );
    }

    GeneralHandler generalHandler = context.watch<GeneralHandler>();
    switch (_listType){
      case "Opposed":
        _gripList = generalHandler.currentUser.opposedActions;
        allGrips =  generalHandler.gripsTyped()[0];
      case "Unopposed":
        _gripList = generalHandler.currentUser.unopposedActions;
        allGrips =  generalHandler.gripsTyped()[1];
      case "Combined":
        _gripList = Map<String,HandAction>.from(generalHandler.currentUser.combinedActions);
        _gripList.remove("Next Grip");
        allGrips =  generalHandler.gripPatterns;
        allGrips.remove("None");
      default:
        _gripList = Map<String,HandAction>.from(generalHandler.currentUser.combinedActions);
        _gripList.remove("Next Grip");
        allGrips =  generalHandler.gripPatterns;
        allGrips.remove("None");
    }
    _items = _gripList.values.toList(); // indeces of this will change
    _actionTitles = _gripList.keys.toList(); //indeces of this will be constant

    return ReorderableListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        shrinkWrap: true,
        children: <Widget>[
          for(var (index, action) in _items.indexed)
            //The list tiles should not be the grip list itself, but rather a list of the grips inside?
            ListTile(
              key: Key("$index"), //This as a key is not great, but will keep it for now
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 Text(_actionTitles[index].substring(_actionTitles[index].length - 1),
                   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                 const SizedBox(width: 15,),
                 Text(generalHandler.currentUser.gripForAction(_actionTitles[index]).name),
                 const Spacer(),
                 ElevatedButton(
                   onPressed: () async{
                     if(!generalHandler.userAccess[1]){
                       var currentTrigger = action.trigger;
                       var triggers = generalHandler.triggers;
                       final newTrigger = await showDialog(
                           context: context,
                           builder: (context) => TriggerSettingDialog(
                               action: _actionTitles[index],
                               currentTrigger: action.triggerName,
                               gripTriggers: triggers));
                       if(newTrigger!=null && newTrigger!= currentTrigger){
                         //Todo: send the update to the hand
                         var newTriggerItem = generalHandler.triggers[newTrigger]!;
                         generalHandler.updateAction(_actionTitles[index], action.grip, newTriggerItem);
                       }
                     }
                   },
                   child: Text(generalHandler.currentUser.triggerForAction(_actionTitles[index]).name),
                 )
               ],
              ),
              onTap: () async{
                //Change the grip
                if(!generalHandler.userAccess[1]){
                  var currentGrip = action.grip;

                  final newGrip = await showDialog(
                      context: context,
                      builder: (context) => GripSettingDialog(
                          action: _actionTitles[index],
                          currentGrip: action.gripName,
                          grips: allGrips));
                  if(newGrip!=null && newGrip!= currentGrip){
                    //Todo: send the update to the hand
                    var newGripItem = generalHandler.gripPatterns[newGrip]!;
                    generalHandler.updateAction(_actionTitles[index], newGripItem, action.trigger);
                  }
                }
              },
              trailing: ReorderableDragStartListener(
                index: index,
                child: const Icon(Icons.drag_handle),
              ),
            ),
        ],
        onReorder: (int oldIndex, int newIndex){

        },


    );
  }

}

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
            const SizedBox(height: 5,),
            TriggersList(
                currentTrigger: _currentTrigger,
                gripTriggers: _gripTriggers,
                changeCurrentTrigger: changeSelectedTrigger),
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