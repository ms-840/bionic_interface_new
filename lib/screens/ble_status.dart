import 'package:auto_size_text/auto_size_text.dart';
import 'package:bionic_interface/firebase_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:bionic_interface/general_handler.dart';
import 'package:bionic_interface/data_handling/ble_interface.dart';
import 'package:qr_flutter/qr_flutter.dart';


class BleStatusPage extends StatefulWidget{
  const BleStatusPage({super.key});

  @override
  State<BleStatusPage> createState() => _BleStatusPageState();
}

class _BleStatusPageState extends State<BleStatusPage>{

  late GeneralHandler generalHandler;
  late BleInterface bleHandler;
  late FirebaseHandler firebaseHandler;

  late ColorScheme theme;
  String deviceName = "";

  @override
  Widget build(BuildContext context) {
    generalHandler = context.watch<GeneralHandler>();
    bleHandler = context.watch<BleInterface>();
    firebaseHandler = context.watch<FirebaseHandler>();

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
          IconButton(
              icon: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
              iconSize: 50,
              padding: EdgeInsets.zero,
              onPressed: (){
                if(Provider.of<FirebaseHandler>(context, listen: false).loggedIn){
                  context.go("/profile");
                }
                else{
                  context.go("/sign-in");
                }
              }
          ),
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

  void updateDeviceName() async{
    deviceName = await firebaseHandler.getHandName(bleHandler.deviceSerialNumber!);
    setState(() {});
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
    if(deviceName==""){
      updateDeviceName();
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
                //(When tapping on it it has QR code that clinician could
                //    use to add device to their things, or get more info )
                // also should contain the disconnect button so its hidden but not gone
                await showDialog(
                    context: context,
                    builder: (context) =>
                        DeviceDetailsDialog(
                          deviceName: deviceName,
                          deviceID: bleHandler.deviceSerialNumber!,)
                );
                setState(() {}); //Reloads page in case there was a disconnection
              },
              onLongPress: () async{
                await showDialog(
                    context: context,
                    builder: (context) =>
                        changeHandNameDialog()
                );
                setState(() {});
              },
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(Icons.bluetooth_connected, size: 60, color: theme.primary,),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Text(bleHandler.selectedDevice.platformName),
                      //Text(bleHandler.selectedDevice.remoteId.toString()),
                      AutoSizeText(deviceName,maxLines: 1,),
                      //The text can only be up to 19 characters long, otherwise the text needs to be smaller
                       AutoSizeText("ID: ${bleHandler.deviceSerialNumber}", maxLines: 1,),
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
              context.go("/ble/grip");
            },
            child: const Text("Grip Settings"),
          ),
          const SizedBox(height: 15,),
          ElevatedButton(
            onPressed: (){
              context.go("/ble/plot");
            },
            child: const Text("Plot"),
          ),
          const SizedBox(height: 15,),
          ElevatedButton(
              onPressed: (){
                context.go("/ble/config");
              },
              child: const Text("Hand Configurations"),
          ),
          const SizedBox(height: 15,),
          //ElevatedButton(onPressed: (){ context.go("/test");}, child: const Text("Test page")),


        ],
      ),
    );
  }

  Dialog changeHandNameDialog(){
    var controller = TextEditingController();
    String defaultName = "Rebel Bionics Hand";
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Change Hand Name"),
            TextField(
              controller: controller,
              onSubmitted: (String value) async{
                if(value.isEmpty){
                  controller.text = defaultName;
                }
              },
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async{
                    if(controller.text.isEmpty){
                      controller.text = defaultName;
                    }
                    firebaseHandler.setHandName(bleHandler.deviceSerialNumber!, controller.text);
                    deviceName = "";
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          ],
        ),
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
  DeviceDetailsDialog({
    super.key,
    required this.deviceName,
    required this.deviceID,
  });
  String deviceName = "";
  String deviceID = "";

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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [AutoSizeText(deviceName, maxLines: 1,),
                        AutoSizeText("ID: $deviceID"),],
                    ),
                    //Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Transform.rotate(
                        angle: 1.570796,
                        child: Icon(bleInterface.batteryStatusIcon,
                          size: 60, color: theme.secondary,),
                      ),
                    ),
                    AutoSizeText(
                      bleInterface.batteryStatus!=null?
                      "${bleInterface.batteryStatus}%":"??"),

                  ],
                ),
              ),

              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: QrImageView(
                  data: deviceID,
                  version: QrVersions.auto,
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
                      onPressed: ()async{
                        //bleInterface.disconnect(); //TODO: implement BLE things
                        print("Disconnect button pushed");
                        Navigator.pop(context);
                        await bleInterface.disconnect();
                        context.go("/");
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

