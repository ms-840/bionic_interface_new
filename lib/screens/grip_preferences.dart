import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bionic_interface/general_handler.dart';
import 'package:bionic_interface/grips.dart';


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
        children: [
          const ThumbTapSwitch(),
          //cycle trigger selector
          Expanded(child: generalHandler.useThumbToggling?
               const DoubleTypeList()
              : const SingleTypeList()),
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
    return Container();
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
        ElevatedButton(
            onPressed: //TOOD: cycle through triggers,
            child: //TODO: trigger name)
      ],
    )
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