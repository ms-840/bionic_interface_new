// this should contain the general handler which contains most of the relevant
// other classes?

import 'package:flutter/material.dart';
import 'data_handling/ble_interface.dart';
import 'dart:async';
import 'user/user.dart';
import 'grips.dart';

class GeneralHandler extends ChangeNotifier{

  //Keys and related ble codes
  final gripPatterns = {
    "Index Point": Grip(name: "Index Point", type: "unopposed", bleCommand: "1", assetLocation: ""),
    "Precision Open": Grip(name: "Precision Open", type: "opposed", bleCommand: "2", assetLocation: ""),
    "Relaxed": Grip(name: "Relaxed", type: "unopposed", bleCommand: "3", assetLocation: ""),
    "Power Grip": Grip(name: "Power Grip", type: "opposed", bleCommand: "4", assetLocation: ""),
    "Hook": Grip(name: "Hook", type: "unopposed", bleCommand: "5", assetLocation: ""),
    "Lateral": Grip(name: "Lateral/Key", type: "unopposed", bleCommand: "6", assetLocation: ""),
    "Tripod": Grip(name: "Tripod", type: "opposed", bleCommand: "7", assetLocation: ""),
    "Mouse": Grip(name: "Mouse", type: "unopposed", bleCommand: "8", assetLocation: ""),
    "Active Index": Grip(name: "Active Index", type: "unopposed", bleCommand: "9", assetLocation: ""),
    "Trigger": Grip(name: "Trigger", type: "opposed", bleCommand: "0", assetLocation: ""),
  };

  List<Grip> unopposedGrips(){
    //TODO: add thing here
  }

  List<Grip> opposedGrips(){
    //TODO: add thing here
  }

  final gripRules = {
    "None": Trigger(name: "None", bleCommand: "0", timeSetting: 0),
    "Open Open": Trigger(name: "Open Open", bleCommand: "1", timeSetting: 0.2),
    "Hold Open": Trigger(name: "Hold Open", bleCommand: "2", timeSetting: 0.2),
    "Co Con": Trigger(name: "Co Con", bleCommand: "3", timeSetting: 0.25),
    "Button Press": Trigger(name: "None", bleCommand: "4"),
    //"Button Hold": Trigger(name: "Button Hold", bleCommand: "5"), // not changeable by user
    //"Thumb Tap": Trigger(name: "Thumb Tap", bleCommand: "6"), // not changeable by user
  }; //include a key for none

  User currentUser = AnonymousUser();
  late BleInterface bleInterface;

  GeneralHandler(this.bleInterface);

  void userLogIn(){
    //TODO: implement
    //currentUser = User()
  }

  List<bool> get userAccess{
    """ returns access in form [adminAccess, childLock]""";
    return [currentUser.hasAdminAccess, currentUser.hasChildLock];
  }

  //#region ble commands
  void updateGripSettingsBle(String grip, String rule){
    //Todo: send the commands for updating grip settings
  }

  //#endregion

}