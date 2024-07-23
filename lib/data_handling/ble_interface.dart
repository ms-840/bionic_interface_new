import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import 'data_buffer.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' show FlutterReactiveBle;

class BleInterface extends ChangeNotifier{
  // this should be used to connect to and receive information from the BLE device

  //initialize
  List<BluetoothDevice> foundBleDevices = []; //required
  late BluetoothDevice selectedDevice;
  String foundDeviceId = "";

  int selectedDeviceIndex = -1; //required
  void changeSelectedDeviceIndex(int index){
    selectedDeviceIndex = index;
    notifyListeners();
  }


  //#region Variables
  //Establish some variables
  //TODO: get the actual serviceUUID and platform name
  String platformName = "";
  Guid serviceUuid = Guid("00000000-cc7a-482a-984a-7f2ed5b3e58f");

  late BluetoothService targetService;



  bool scanning = false;
  bool connected = false;
  bool permissionsGranted = false;
  bool subscribedToNotifications = false;
  bool servicesFound= false;
  bool deviceSetUp = false;
  bool connectionError = false;
  bool disconnectDesired = false;

  ///An integer representing the battery status (in percent)
  ///as transmitted by the connected hand.
  ///The icons are set up according to the following percentages:
  ///-
  ///When unconnected, it returns
  int? batteryStatus = 70;
  IconData get batteryStatusIcon{
    switch (batteryStatus){
      case null: return Icons.bluetooth;
      case < 10: return Icons.battery_0_bar_sharp;
      case < 20: return Icons.battery_1_bar_sharp;
      case < 30: return Icons.battery_2_bar_sharp;
      case < 40: return Icons.battery_3_bar_sharp;
      case < 50: return Icons.battery_4_bar_sharp;
      case < 65: return Icons.battery_5_bar_sharp;
      case < 75: return Icons.battery_6_bar_sharp;
      case < 85: return Icons.battery_full_sharp;
      default: return Icons.error_outline;
    }
  }


  //the unchanged data from the ble connection is stored in this buffer
  DataBuffer receivedDataBuffer = DataBuffer(maxBufferSize: 1000, targetFillPercentage: 0.01);


  //according to documentation, we should wait for the BleStatus.ready
  // from the statusStream to make sure the BLE-stack is properly initialized
  //before calling any of the other BLE operations

  //#endregion

  //#region Permission setup
  Future<bool> getPermissions() async{
    """ Get the necessary permissions from the user (Bluetooth and location) """;
    // ensure that the appropriate permissions have been given
    // return true when permissions are good to go
    PermissionStatus locationPermission = await Permission.location.status;
    //await explainPermissions(); //removed because its actually just more annoying
    locationPermission = await Permission.location.request();
    //print(locationPermission);

    PermissionStatus bluetoothPermissionConnect = await Permission.bluetoothConnect.status;
    PermissionStatus bluetoothPermissionScan = await Permission.bluetoothScan.status;
    //TODO: i am not sure if this is valid for both android and ios

    //you do need to request both permissions, or you will not get both, even if it is only one pup up for the user
    if(!bluetoothPermissionScan.isGranted){

      //print("Attempting to get Ble permissions scan");
      bluetoothPermissionConnect = await Permission.bluetoothScan.request();
      //print(bluetoothPermissionScan);
    }
    if(!bluetoothPermissionConnect.isGranted){
      //print("Attempting to get Ble permissions connection");
      bluetoothPermissionConnect = await Permission.bluetoothConnect.request();
      //print(bluetoothPermissionConnect);
    }


    //This ensures the await calls have come back before it continues
    //From my limited testing this should also work if the user takes their time answering  the prompt
    sleep(const Duration(seconds:1));

    if(bluetoothPermissionConnect.isGranted || bluetoothPermissionScan.isGranted){
      //if one of them is true, then the other will also become true at some point
      permissionsGranted = true;
      return true;
    }

    //If this code runs, permissions were not granted
    print("Permissions not granted");
    //await showNoPermissionDialog();
    return false;
  }
  //#endregion

  void searchForBLE() async {
    if(permissionsGranted) { //only run this if the permissions have been handled

      // Setup Listener for scan results.
      // device not found? see "Common Problems" in the README
      FlutterBluePlus.scanResults.listen(
            (results) {
          scanning = true;
          for (ScanResult r in results) {
            if (foundBleDevices.contains(r.device) == false &&
                r.device.platformName == platformName) {
              print('${r.device.remoteId}: "${r.advertisementData.localName}" found! rssi: ${r.rssi}');
              foundBleDevices.add(r.device);
              notifyListeners();
            }
          }
        },
      );

      await FlutterBluePlus.startScan();

    } else { //permissions have not been granted, need to try again
      print("Need to get permissions");
      await getPermissions();
      searchForBLE();
    }
  }

  //#region connect to device and identify services

  var previousConnectedDevices = 0;
  late StreamSubscription<int> mtuSubscription;

  Future<bool> connectToDevice() async{
    connectionError = false;
    selectedDevice = foundBleDevices[selectedDeviceIndex];
    print("Attempting to connect to ${selectedDevice.platformName}"
        " with id ${selectedDevice.remoteId}");
    previousConnectedDevices = (await FlutterBluePlus.connectedSystemDevices).length;

    // listen for disconnection
    selectedDevice.connectionState.listen((BluetoothConnectionState state) async {
      if (state == BluetoothConnectionState.disconnected) {
        // 1. typically, start a periodic timer that tries to
        //    periodically reconnect, or just call connect() again right now
        // 2. you must always re-discover services after disconnection!
        // 3. you should cancel subscriptions to all characteristics you listened to

        if(!disconnectDesired){
          // Connect to the device
          // Note: You should always call `connectionState.listen` before you call connect!
          print("attempting to connect");
          await selectedDevice.connect(timeout: const Duration(seconds: 35)).catchError((error) {
            print("Connection Error: $error");
            connectionError = true;
            //return false;
          });
          //print("Device ${selectedDevice.platformName} should be connected");
          if((await FlutterBluePlus.connectedSystemDevices).length > previousConnectedDevices){
            //connection was successful


            mtuSubscription = selectedDevice.mtu.listen((int mtu) {
              // iOS: initial value is always 23, but iOS will quickly negotiate a higher value
              // android: you must request higher mtu yourself
              print("mtu $mtu");
            });
            // cleanup: cancel subscription when disconnected
            selectedDevice.cancelWhenDisconnected(mtuSubscription);
            negotiateMTU(156, foundDeviceId);

            await identifyServices();
            connected = true;
            foundDeviceId = selectedDevice.remoteId.toString();



            //deviceSetUp = true;
            notifyListeners();

          }
          else{
            //Disconnection was successful, now change so connection can work again
            disconnectDesired = false;
          }
        }
      }else{
        print("connection already established with ${selectedDevice.platformName}");
        identifyServices();
        connected = true;
      }
    });
    return true;
  }

  Future<void> negotiateMTU(int newMtu, String id)async {
    final flutterReactiveBle = FlutterReactiveBle();
    await flutterReactiveBle.requestMtu(deviceId: id, mtu: newMtu);
    flutterReactiveBle.deinitialize();
  }


  Future<void> identifyServices() async {
    // Note: You must call discoverServices after every connection!
    List<BluetoothService> services = await selectedDevice.discoverServices();
    for(var service in services){
      print("service ${service.serviceUuid}");
      if(service.serviceUuid == serviceUuid){
        //This is the target service
        print("Service Found");
        servicesFound = true;
        targetService = service;
        notifyListeners();

        //if we need to target more than one service,
        // this should be converted to a list
      }
    }
  }

  //#endregion

  //#region Read, Write, Notify
  void readCharacteristic() async{
    for(BluetoothCharacteristic characteristic in targetService.characteristics) {
      if(characteristic.properties.read){
        List<int> value = await characteristic.read();
        print(value);
      }
    }
  }

  Future<void> writeToCharacteristic(List<int> valueToWrite) async{
    for(BluetoothCharacteristic characteristic in targetService.characteristics) {
      if(characteristic.properties.write ||
          characteristic.properties.writeWithoutResponse){
        return await characteristic.write(valueToWrite);
      }
    }
  }


  void subscribeToCharacteristic() async {
    await selectedDevice.requestConnectionPriority(connectionPriorityRequest: ConnectionPriority.high);
    for(BluetoothCharacteristic characteristic in targetService.characteristics) {
      if(characteristic.properties.notify){
        print("Notify property detected");


        // enable notifications
        await characteristic.setNotifyValue(true);
        subscribedToNotifications = true;
        notifyListeners();
        print("Subscribed to notifications");

        final subscription = characteristic.lastValueStream.listen((value) {
          //TODO: add what to do with incoming data

        });

        // listen for disconnection to stop subscription
        selectedDevice.connectionState.listen((BluetoothConnectionState state) {
          if (state == BluetoothConnectionState.disconnected) {
            // stop listening to characteristic
            subscription.cancel();
          }
        });
      }
    }
  }

  void addDataToReceivedData(List<int> data){
    receivedDataBuffer.addToBuffer(data);
  }

  void checkDataIsComplete(List<int> data){
    """ Check that the data is complete when received""";
    //TODO: implement new ways of checking

  }


  void unsubscribeFromCharacteristic() async{
    for(BluetoothCharacteristic characteristic in targetService.characteristics) {
      if(characteristic.properties.notify){
        // disable notifications
        await characteristic.setNotifyValue(false);
        print("Unsubscribed from notifications");
        subscribedToNotifications = false;
        notifyListeners();
      }
    }

  }


  //#endregion


  void disconnect() async {
    // Disconnect from device
    disconnectDesired = true;
    await selectedDevice.disconnect();
    connected = false;
    servicesFound = false;
    deviceSetUp = false;
    foundBleDevices.clear();
    disconnectDesired = false;
    notifyListeners();
    receivedDataBuffer.emptyBuffer();

  }

  void stopScan() async {
    // Stop scanning
    await FlutterBluePlus.stopScan();
    scanning = false;
  }


}