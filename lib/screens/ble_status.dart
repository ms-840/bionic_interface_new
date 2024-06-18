import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BleStatusPage extends StatefulWidget{
  const BleStatusPage({super.key});

  @override
  State<BleStatusPage> createState() => _BleStatusPageState();
}

class _BleStatusPageState extends State<BleStatusPage>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: (){
            context.go("/");
          },
        ),
        title: const Text("Hand Status"),
        actions: [
          const SizedBox.shrink(),
          Image.asset('assets/images/logo.png', fit: BoxFit.contain, height: 50,),
          const SizedBox(width: 10,)
        ],
      ),
      body: const Text("Nothing here yet"),
    );
  }
}