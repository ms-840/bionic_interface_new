import 'package:bionic_interface/data_handling/ble_interface.dart';
import 'package:bionic_interface/general_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bionic_interface/firebase_handler.dart';
import 'package:go_router/go_router.dart';
//TODO: change this to a different screen
// it should allow you to select and connect to a nearby hand and prompt you where to go?
// maybe have ble connection be a thing that happens before, also need something to log in

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ensureDisconnected(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: (){
            context.go("/");
          },
        ),
        title: const Text("Rebel Bionics"),
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
          ),          const SizedBox(width: 10,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            newUserButtonCard(context),
            BleDeviceList(),
            refresh(context),
              ],
        ),
      ),
    );
  }

  void ensureDisconnected(BuildContext context){
    if(Provider.of<BleInterface>(context, listen:false).connected){
      Provider.of<BleInterface>(context, listen:false).disconnect();
    }
  }

  Widget refresh(BuildContext context){
    return TextButton(
        onPressed: (){
          Provider.of<BleInterface>(context, listen:false).searchForBLE();
          },
        child: const Text("Refresh")
    );
  }

  Widget newUserButtonCard(BuildContext context){
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          leading: const Icon(Icons.login, color: Colors.white,),
          title:  Provider.of<FirebaseHandler>(context, listen: true).loggedIn?
            const Text("View Profile", style: TextStyle(color: Colors.white))
                : const Text("Login", style: TextStyle(color: Colors.white),),
          tileColor: Theme.of(context).colorScheme.primary,
          onTap: (){
            //Navigator.popAndPushNamed(context, "/selectAccount");
            print(Provider.of<FirebaseHandler>(context, listen: false).loggedIn);
            Provider.of<FirebaseHandler>(context, listen: false).loggedIn?
              context.go("/profile") : context.go("/sign-in");
          },
        ),
      ),
    );
  }

}

/// This should be a big swipable button that shows you the available rebel devices, if theres multiple if should show the
/// when clicked, the app should connect to the device and go to the device screen
/// only have an outline if no device is found
class BleDeviceList extends StatelessWidget{

  late BleInterface bleHandler;

  @override
  Widget build(BuildContext context) {
    bleHandler = Provider.of<BleInterface>(context, listen:true);
    var devices = bleHandler.foundBleDevices;
    return devices.length > 0? Expanded(
      child: DefaultTabController(
          length: devices.length,
          child: TabBarView(
              children: [
                for(var device in devices) deviceTabs(context, device.platformName, device.remoteId.toString())
              ]
      ),
    ),
    ) : const Text("No devices found");
  }

  ///Returns a widget to display an available device
  Widget deviceTabs(BuildContext context, String deviceName, String deviceId){
    return InkWell(
      onTap: () async {
        print("Connected");
        var result = await bleHandler.connectToDevice(deviceId);
        if (result){
          context.go("/ble");
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/grips/relaxed.png', fit:BoxFit.contain),
          Text(deviceName),
          Text(deviceId)
        ],
      ),
    );
  }


}

