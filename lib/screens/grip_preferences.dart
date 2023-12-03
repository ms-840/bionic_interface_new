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
          const ReorderableExample(),
          /*
          Expanded(child: generalHandler.useThumbToggling?
               const DoubleTypeList()
              : const SingleTypeList()
          ),

           */

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
    return Row(
      children: [
        const Text("Use thumb tap toggling"),
        const SizedBox.shrink(),
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
    );
  }

}

class SingleTypeList extends StatelessWidget{
  const SingleTypeList({super.key});

  @override
  Widget build (BuildContext context){
    //TODO: this should be more like a list view thing
    return const ReorderableGripList(listType: "Combined");
  }
}

class CycleTriggerSelector extends StatelessWidget{
  const CycleTriggerSelector({super.key});

  @override
  Widget build(BuildContext context){
    var generalHandler = context.watch<GeneralHandler>();
    return Row(
      children: [
        const Text("Trigger for Cycling"),
        const SizedBox.shrink(),
        ElevatedButton(
            onPressed: () async{
              if(!generalHandler.userAccess[1]){
               var currentTrigger = generalHandler.currentUser.triggerForAction("Next Grip")!;
               var triggers = generalHandler.triggers;
               final newTrigger = await showDialog(
                   context: context,
                   builder: (context) => SettingDialog(
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
    );
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
            TabBarView(
                children: [
                  //TODO: listview with opposed
                  //TODO: listview with unopposed
                ],
            ),
          ],
        ));
  }
}

class ReorderableExample extends StatefulWidget {
  const ReorderableExample({super.key});

  @override
  State<ReorderableExample> createState() => _ReorderableListViewExampleState();
}

class _ReorderableListViewExampleState extends State<ReorderableExample> {
  final List<int> _items = List<int>.generate(50, (int index) => index);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    return ReorderableListView(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      shrinkWrap: true,
      children: <Widget>[
        for (int index = 0; index < _items.length; index += 1)
          ListTile(
            key: Key('$index'),
            tileColor: _items[index].isOdd ? oddItemColor : evenItemColor,
            title: Text('Item ${_items[index]}'),
          ),
      ],
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final int item = _items.removeAt(oldIndex);
          _items.insert(newIndex, item);
        });
      },
    );
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
      case "Unopposed":
        _gripList = generalHandler.currentUser.unopposedActions;
      case "Combined":
        _gripList = generalHandler.currentUser.combinedActions;
        _gripList.remove("Next Grip");
      default:
        _gripList = generalHandler.currentUser.combinedActions;
        _gripList.remove("Next Grip");
    }
    _items = _gripList.values.toList(); // indeces of this will change
    _actionTitles = _gripList.keys.toList(); //indeces of this will be constant

    return ReorderableListView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        shrinkWrap: true,
        children: <Widget>[
          for(var (index, action) in _items.indexed)
            //The list tiles should not be the grip list itself, but rather a list of the grips inside?
            ListTile(
              key: Key("$index"), //This as a key is not great, but will keep it for now
              title: Row(
               children: [
                 Text(_actionTitles[index]),
                 const SizedBox.shrink(),
                 Text(action.gripName),
                 const SizedBox.shrink(),
                 ElevatedButton(
                   onPressed: () async{
                     if(!generalHandler.userAccess[1]){
                       var currentTrigger = action.trigger;
                       var triggers = generalHandler.triggers;
                       final newTrigger = await showDialog(
                           context: context,
                           builder: (context) => SettingDialog(
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
              onTap: (){
                //Change the grip

              },
            ),
        ],
        onReorder: (int oldIndex, int newIndex){

        }
    );
  }

}

class SettingDialog extends StatefulWidget{

  final String action;
  final String currentTrigger;
  final Map<String, Trigger> gripTriggers;

  const SettingDialog({super.key,
    required this.action,
    required this.currentTrigger,
    required this.gripTriggers,
  });

  @override
  State<SettingDialog> createState() => _SettingsDialog();

}

class _SettingsDialog extends State<SettingDialog>{

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
            /*
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

             */
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
          leading: const Text("image?"), //this should be the relevant image
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