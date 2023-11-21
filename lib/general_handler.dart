// this should contain the general handler which contains most of the relevant
// other classes?

import 'package:flutter/material.dart';
import 'data_handling/ble_interface.dart';
import 'dart:async';
import 'user/user.dart';

class GeneralHandler extends ChangeNotifier{

  //Keys and related ble codes
  final gripPatterns = {"gripName": 0, };
  final gripRules = {"patternName": 0, };

  late User currentUser;
  late BleInterface bleInterface;

  GeneralHandler(this.bleInterface){
    currentUser = AnonymousUser();
  }

  void userLogIn(){
    //TODO: implement
    //currentUser = User()
  }

  List<bool> get userAccess{
    """ returns access in form [adminAccess, childLock]""";
    return [currentUser.hasAdminAccess, currentUser.hasChildLock];
  }

}