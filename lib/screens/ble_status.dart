import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:bionic_interface/general_handler.dart';
import 'package:bionic_interface/data_handling/ble_interface.dart';


class BleStatusPage extends StatefulWidget{
  const BleStatusPage({super.key});

  @override
  State<BleStatusPage> createState() => _BleStatusPageState();
}

class _BleStatusPageState extends State<BleStatusPage>{

  late GeneralHandler generalHandler;
  late BleInterface bleHandler;

  late ColorScheme theme;

  @override
  Widget build(BuildContext context) {
    generalHandler = context.watch<GeneralHandler>();
    bleHandler = context.watch<BleInterface>();

    theme = Theme.of(context).colorScheme;

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: true?  connectedDevice() : unconnectedDevice(), //bleHandler.connected?
        //TODO: implement BLE things
        //if ble device is not connected show connection screen,
        // if connected show connectedDevice
      ),
    );
  }

  Widget connectedDevice(){
    if(false){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30,),
          Center(child:
          Text("Loading device details",
            style: TextStyle(fontSize: 20, color: theme.primary),)),
          const SizedBox(height: 15,),
          const CircularProgressIndicator(),
          //TODO: Loading Circle
        ],
      );
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 15,),
          Card(
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: () async {
                //TODO: open a pop up with
                print("Information card was tapped");
                //(When tapping on it it has QR code that clinician could
                //    use to add device to their things, or get more info )
                // also should contain the disconnect button so its hidden but not gone
                await showDialog(
                    context: context,
                    builder: (context) =>
                        DeviceDetailsDialog()
                );
                setState(() {}); //Reloads page in case there was a disconnection
              },
              onLongPress: (){
                print("Long press detected");
              },
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(Icons.bluetooth_connected, size: 60, color: theme.primary,),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Text(bleHandler.selectedDevice.platformName),
                      //Text(bleHandler.selectedDevice.remoteId.toString()),
                      Text("Device Name ", style: TextStyle(fontSize: 20),),
                      //TODO: Replace with autosizeText widget - https://pub.dev/documentation/auto_size_text/latest/
                      //The text can only be up to 19 characters long, otherwise the text needs to be smaller
                      Text("ID: 0123456789"),
                    ],
                  ),
                  /*ElevatedButton( //Im not certain i want this here actually
                      onPressed: (){
                        print("This would be disconnecting");
                        //bleHandler.disconnect();
                      },
                    style: ElevatedButton.styleFrom(backgroundColor: theme.secondary),
                      child: const Text("Disconnect", style: TextStyle(color: Colors.white),),
                  ),
                   */
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Transform.rotate(
                      angle: 1.570796,
                        child: Icon(bleHandler.batteryStatusIcon,
                              size: 60, color: theme.secondary,),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15,),
          Image.asset('assets/images/logo.png', fit: BoxFit.contain, height: 200,),
          const Text("A render of hand could be here,\n or alternatively some sort of readout?"),
          const SizedBox(height: 15,),
          ElevatedButton(
            onPressed: (){
              print("This should lead to the grip settings page");
              context.go("/grip");
            },
            child: const Text("Grip Settings"),
          ),
          const SizedBox(height: 15,),
          ElevatedButton(
            onPressed: (){
              print("This should lead to the Plot page where gains can be set as well");
              context.go("/plot");
            },
            child: const Text("Plot"),
          ),
          const SizedBox(height: 15,),
          ElevatedButton(
              onPressed: (){
                print("This should go to a page where configurations/advanced settings "
                    "can be set and saved to/recovered from firebase");
                // sync button with firebase
                // option to save current config
                // list of available backed up configs
                //    when double tapped, gives dialog to ask if the config file should overwrite current things
                context.go("/config");
              },
              child: const Text("Hand Configurations"),
          ),
          const SizedBox(height: 15,),
          ElevatedButton(onPressed: (){ context.go("/test");}, child: const Text("Test page")),


        ],
      ),
    );
  }

  Widget unconnectedDevice(){
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //Search button/refresh?
        // list of avaliable devices
        // connect button at the top
      ],
    );
  }

}

class DeviceDetailsDialog extends StatelessWidget{
  const DeviceDetailsDialog({super.key});

  //Stateless since we are not keeping any data specifically in this class but pulling it all from the BLE Interface

  @override
  Widget build(BuildContext context) {
    BleInterface bleInterface = context.watch<BleInterface>();
    ColorScheme theme = Theme.of(context).colorScheme;
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text("Device Name ", style: TextStyle(fontSize: 20),),
                        //TODO: Replace with autosizeText widget - https://pub.dev/documentation/auto_size_text/latest/
                        //The text can only be up to 19 characters long, otherwise the text needs to be smaller
                        Text("ID: 0123456789"),],
                    ),
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Transform.rotate(
                        angle: 1.570796,
                        child: Icon(bleInterface.batteryStatusIcon,
                          size: 60, color: theme.secondary,),
                      ),
                    ),
                    Text(
                      bleInterface.batteryStatus!=null?
                      "${bleInterface.batteryStatus}%":"??",
                      style: const TextStyle(fontSize: 20),),

                  ],
                ),
              ),

              const SizedBox(height: 10,),
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                  child: const Text("<QR CODE OF DEVICE ID HERE>"),
                ),
              ),
              const SizedBox(height: 10,),
              const Text("Other Details: <Other potential detail>"),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: theme.secondary,
                          foregroundColor: theme.background
                      ),
                      onPressed: (){
                        //bleInterface.disconnect(); //TODO: implement BLE things
                        print("Disconnect button pushed");
                        Navigator.pop(context);
                      },
                      child: const Text("Disconnect")
                  ),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("Back"),
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

