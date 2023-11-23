// this should contain the general handler which contains most of the relevant
// other classes?

import 'package:flutter/material.dart';
import 'data_handling/ble_interface.dart';
import 'dart:async';
import 'user/user.dart';

class GeneralHandler extends ChangeNotifier{

  //Keys and related ble codes
  final gripPatterns = {"grip 1": 0, "grip 2": 1, "grip 3":2, "grip 4":3};
  final gripRules = {"None":0, "rule 1": 1, "rule 2":2, "rule 3":3}; //include a key for none

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