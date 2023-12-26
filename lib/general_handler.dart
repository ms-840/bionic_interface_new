// this should contain the general handler which contains most of the relevant
// other classes?

import 'package:flutter/material.dart';
import 'data_handling/ble_interface.dart';
import 'dart:async';
import 'user/user.dart';
import 'grip_trigger_action.dart';

class GeneralHandler extends ChangeNotifier{
  late BleInterface bleInterface;

  GeneralHandler(this.bleInterface);

  //Keys and related ble codes
  final gripPatterns = {
    "None":           Grip(name: "None",           type: "",          bleCommand: "",  assetLocation: "assets/images/logo_grey.png"),
    "Index Point":    Grip(name: "Index Point",    type: "unopposed", bleCommand: "1", assetLocation: "assets/images/grips/index_point.png"),
    "Precision Open": Grip(name: "Precision Open", type: "opposed",   bleCommand: "2", assetLocation: "assets/images/grips/precision_open.png"),
    "Relaxed":        Grip(name: "Relaxed",        type: "unopposed", bleCommand: "3", assetLocation: "assets/images/grips/relaxed.png"),
    "Power Grip":     Grip(name: "Power Grip",     type: "opposed",   bleCommand: "4", assetLocation: "assets/images/grips/power_grip.png"),
    "Hook":           Grip(name: "Hook",           type: "unopposed", bleCommand: "5", assetLocation: "assets/images/grips/hook.png"),
    "Key":            Grip(name: "Key",            type: "unopposed", bleCommand: "6", assetLocation: "assets/images/grips/lateral_key.png"),
    "Tripod":         Grip(name: "Tripod",         type: "opposed",   bleCommand: "7", assetLocation: "assets/images/grips/tripod.png"),
    "Mouse":          Grip(name: "Mouse",          type: "unopposed", bleCommand: "8", assetLocation: "assets/images/grips/mouse.png"),
    "Active Index":   Grip(name: "Active Index",   type: "unopposed", bleCommand: "9", assetLocation: "assets/images/grips/active_index.png"),
    "Trigger":        Grip(name: "Trigger",        type: "opposed",   bleCommand: "0", assetLocation: "assets/images/grips/trigger.png"),
  };

  List<Map<String,Grip>> gripsTyped(){
    """ Returns [opposedGrips, unopposedGrips] """;
    Map<String,Grip> opposedGrips = {};
    Map<String,Grip> unopposedGrips = {};
    for (var grip in gripPatterns.keys){
      if(gripPatterns[grip]!.type == "opposed"){
        opposedGrips[grip] = gripPatterns[grip]!;
      } else if(gripPatterns[grip]!.type == "unopposed"){
        unopposedGrips[grip] = gripPatterns[grip]!;
      }
    }
    return [opposedGrips, unopposedGrips];
  }


  final triggers = {
    "None":         Trigger(name: "None",        bleCommand: "0"),
    "Open Open":    Trigger(name: "Open Open",   bleCommand: "1", timeSetting: 0.2),
    "Hold Open":    Trigger(name: "Hold Open",   bleCommand: "2", timeSetting: 0.2),
    "Co Con":       Trigger(name: "Co Con",      bleCommand: "3", timeSetting: 0.25),
    "Button Press": Trigger(name: "Button Press",bleCommand: "4"),
    //"Button Hold":Trigger(name: "Button Hold", bleCommand: "5"), // not changeable by user
    //"Thumb Tap":  Trigger(name: "Thumb Tap",   bleCommand: "6"), // not changeable by user
  }; //include a key for none

  void getUnusedTriggers(){

  }

  Map<String, Grip> getUnusedGrips(String gripType){
    """ gripType can be:
        - 'Opposed'
        - 'Unopposed'
        - 'Combined'
    """;
    late Map<String, Grip> unusedGrips;
    switch(gripType){
      case("Opposed"):
        unusedGrips = gripsTyped()[0];
        for(var gripItem in currentUser.opposedActions.values){
          if(unusedGrips.containsKey(gripItem.gripName)){
            unusedGrips.remove(gripItem.gripName);
          }
        }
      case("Unopposed"):
        unusedGrips = gripsTyped()[1];
        for(var gripItem in currentUser.unopposedActions.values){
          if(unusedGrips.containsKey(gripItem.gripName)){
            unusedGrips.remove(gripItem.gripName);
          }
        }
      case("Combined"):
        unusedGrips = Map<String,Grip>.from(gripPatterns);
        for(var gripItem in currentUser.combinedActions.values){
          if(unusedGrips.containsKey(gripItem.gripName)){
            unusedGrips.remove(gripItem.gripName);
          }
        }
    }
    return unusedGrips;
  }

  void addGripsToUserList(String type){
    switch(type){
      case "Opposed":
        currentUser.addOpposedAction();
      case "Unopposed":
        currentUser.addUnopposedAction();
      case "Combined":
        currentUser.addCombinedAction();
    }
    notifyListeners();
  }

  User currentUser = AnonymousUser();


  void userLogIn(){
    //TODO: implement
    //currentUser = User()
  }

  List<bool> get userAccess{
    """ returns access in form [adminAccess, childLock]""";
    return [currentUser.hasAdminAccess, currentUser.hasChildLock];
  }

  bool get useThumbToggling{
    return currentUser.useThumbToggling;
  }

  void toggleThumbTapUse(){
    currentUser.toggleThumbTap();
    notifyListeners();
  }

  void updateAction(String action, Grip? grip, Trigger? trigger){
    if(useThumbToggling){
      currentUser.setUnOpposedAction(action: action, grip: grip, trigger: trigger);
    }
    else {
      currentUser.setCombinedAction(action: action, grip: grip, trigger: trigger);
    }

    notifyListeners();
  }

  //#region ble commands
  void updateGripSettingsBle(String grip, String rule){
    //Todo: send the commands for updating grip settings
  }

  //#endregion

}