import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:bionic_interface/general_handler.dart';
import 'package:bionic_interface/grip_trigger_action.dart';
import 'grip_preferences_auxiliary/grip_dialog.dart';
import 'grip_preferences_auxiliary/trigger_dialog.dart';


class GripSettings extends StatelessWidget{
  const GripSettings({super.key});

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
          //const CycleTriggerSelector(),
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
                if(generalHandler.userAccess < 1){
                 var currentTrigger = generalHandler.currentUser.triggerForAction("Next Grip");
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
    return const DefaultTabController(
        length: 2,
        child:  Column(
          children: [
            TabBar(
              tabs: [
                Text("Grips"),
                Text("Direct"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ReorderableGripList(listType: "Combined"),
                  DirectGripList(),
                ],
              ),
            ),
          ],
        ));
  }
}

class DoubleTypeList extends StatelessWidget{
  const DoubleTypeList({super.key});

  @override
  Widget build (BuildContext context){
    return const DefaultTabController(
        length: 3,
        child:  Column(
          children: [
             TabBar(
                tabs: [
                  Text("Opposed"),
                  Text("Unopposed"),
                  Text("Direct"),
                ],
            ),
            Expanded(
              child: TabBarView(
                  children: [
                    ReorderableGripList(listType: "Opposed"),
                    ReorderableGripList(listType: "Unopposed"),
                    DirectGripList(),
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

  bool enableRemoveState = false;

  @override
  void initState(){
    super.initState();
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
        //allGrips =  generalHandler.gripsTyped()[0];
      case "Unopposed":
        _gripList = generalHandler.currentUser.unopposedActions;
        //allGrips =  generalHandler.gripsTyped()[1];
      case "Combined":
        _gripList = Map<String,HandAction>.from(generalHandler.currentUser.combinedActions);
        _gripList.remove("Next Grip");
        //allGrips = Map<String,Grip>.from(generalHandler.gripPatterns);
        //allGrips.remove("None");
      default:
        _gripList = Map<String,HandAction>.from(generalHandler.currentUser.combinedActions);
        _gripList.remove("Next Grip");
    }
    allGrips =  Map<String,Grip>.from(generalHandler.getUnusedGrips(_listType));
    allGrips.remove("Next Grip");
    //print(allGrips.keys.toList());
    //allGrips.remove("None");
    _items = _gripList.values.toList(); // indeces of this will change
    _actionTitles = _gripList.keys.toList(); //indeces of this will be constant

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          ReorderableListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              physics : const NeverScrollableScrollPhysics(),
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
                       const SizedBox(width: 20,),
                       Image.asset(generalHandler.gripPatterns[generalHandler.currentUser.gripForAction(_actionTitles[index]).name]!.assetLocation,
                         fit: BoxFit.contain,
                         height: 80,),
                       Expanded(
                         child: SingleChildScrollView(
                           scrollDirection: Axis.horizontal,
                             child: Text(generalHandler.currentUser.gripForAction(_actionTitles[index]).name)),
                       ),
                       /*
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
                       */
                     ],
                    ),
                    onTap: () async{
                      //Change the grip
                      if(generalHandler.userAccess < 1){
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
                    trailing: enableRemoveState? IconButton(
                        onPressed: (){
                          generalHandler.removeGripFromUserList(_listType, _actionTitles[index]);
                        },
                        style: IconButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.secondary,
                        ),
                        icon: const Icon(Icons.delete)
                    )
                        :
                    ReorderableDragStartListener(
                      index: index,
                      child: index == 0 ? const Icon(Icons.home):  const Icon(Icons.drag_handle),
                    ),
                  ),
              ],
              onReorder: (int oldIndex, int newIndex){
                /* how this needs to work:
                  when reordered, each of the Hand actions needs to to be re-attributed to the action titles
                  1. figure out the indeces of the old hand action tiles -> that is _items
                  2. reorder the tiles
                  3. reattribute
                 */
                setState(() {
                  //Reorder the tiles
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final HandAction item = _items.removeAt(oldIndex);
                  _items.insert(newIndex, item);
                });

                //reattribute the hand actions to the actions
                for(var (index, action) in _actionTitles.indexed){
                  var newGrip = _items[index].grip;
                  var newTrigger = _items[index].trigger;
                  generalHandler.updateAction(action, newGrip, newTrigger);
                }
              },
          
          ),
          ElevatedButton(
              onPressed: enableRemoveState? null : (){
                generalHandler.addGripsToUserList(_listType);
              },
              child: const Icon(Icons.add)),
          const SizedBox(height: 10,),
          ElevatedButton(
              style: enableRemoveState? ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
              ) : ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.secondary,
                backgroundColor: const Color(0xFFfee6f5),
              )
              ,
              onPressed: (){
                setState(() {
                  enableRemoveState = !enableRemoveState;
                  print(enableRemoveState);
                });
              },
              child: const Icon(Icons.remove)),
        ],

      ),
    );
  }

}

class DirectGripList extends StatefulWidget{
  const DirectGripList({super.key});


  @override
  State<DirectGripList> createState() => _DirectGripListState();
}

class _DirectGripListState extends State<DirectGripList>{

  Row gripRow(Grip grip){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(grip.assetLocation,
          fit: BoxFit.contain,
          height: 80,),
        const SizedBox(width: 5,),
        Text(grip.name),
      ],
    );
  }

  @override
  Widget build(BuildContext context){
    /*
    Ideas for this part:
    could be a list view, with each Trigger and then what it is connected to?
    Things that need to be on each trigger tile:
    - the name of the trigger
    - what it is connected to (ie trigger or next grip)
    - a gear/setting symbol/some way to change the time settings for the ones where you can?
     */
    GeneralHandler generalHandler = context.watch<GeneralHandler>();
    List<HandAction> directActions = generalHandler.currentUser.directActions.values.toList();

    return ListView.builder(
        shrinkWrap: true,
        itemCount: directActions.length,
        itemBuilder: (BuildContext context, int index){
        var action = directActions[index];
        return ListTile(
          title: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(action.triggerName),
                //const SizedBox.expand(),
                action.gripName != "None" && action.gripName != "Next Grip" ? gripRow(action.grip!) :
                action.gripName == "None"? Text(action.gripName, style: TextStyle(color: Theme.of(context).colorScheme.secondary),) : Text(action.gripName,)
                //const SizedBox.shrink(),
                /*action.trigger?.timeSetting != null? IconButton(
                    onPressed: (){

                    },
                    padding: const EdgeInsets.all(5),
                    icon: const Icon(Icons.settings, size: 20,))
                    : Container(width: 40,),
                 */
              ],
            ),
          ),
          onTap: () async {
            var currentGrip = action.grip;
            var allGrips = Map<String, Grip>.from(generalHandler.gripPatterns);
            final newGrip = await showDialog(
                context: context,
                builder: (context) =>
                    GripSettingDialog(
                        action: "Direct",
                        currentGrip: action.gripName,
                        grips: allGrips));
            if (newGrip != null && newGrip != currentGrip) {
              //Todo: send the update to the hand
              var newGripItem = generalHandler.gripPatterns[newGrip]!;
              generalHandler.updateAction(
                  "direct", newGripItem, action.trigger);
            }

          },
        );
        }
    );
  }

}

