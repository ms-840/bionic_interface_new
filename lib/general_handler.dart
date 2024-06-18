// this should contain the general handler which contains most of the relevant
// other classes?

import 'package:flutter/material.dart';
import 'data_handling/ble_interface.dart';
import 'data_persistence/database_interface.dart';
import 'dart:async';
import 'user/user.dart';
import 'grip_trigger_action.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';

class GeneralHandler extends ChangeNotifier{
  late BleInterface bleInterface;
  late DbInterface _dbInterface;

  GeneralHandler(this.bleInterface){
    _dbInterface = DbInterface();
    print("General Handler initialized");
  }

  //Keys and related ble codes
  final gripPatterns = {
    "None":           Grip(name: "None",           type: "",          bleCommand: "",  assetLocation: "assets/images/logo_grey.png"),
    "Next Grip":      Grip(name: "Next Grip",      type: "",          bleCommand: "",  assetLocation: "assets/images/logo_grey.png"),
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


  ///Returns 
  ///gripType can be:
  /// - 'Opposed'
  /// - 'Unopposed'
  /// - 'Combined'
  Map<String, Grip> getUnusedGrips(String gripType){
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

  /// add the specified grip from the specified list type. Available types:
  /// - 'Opposed'
  /// - 'Unopposed'
  /// - 'Combined'
  void addGripsToUserList(String type){
    switch(type){
      case "Opposed":
        if(gripsTyped()[0].length > currentUser.opposedActions.length){
          currentUser.addOpposedAction();
        }

      case "Unopposed":
        if(gripsTyped()[1].length > currentUser.unopposedActions.length){
          currentUser.addUnopposedAction();
        }
      case "Combined":
        if(gripPatterns.length - 2 > currentUser.combinedActions.length) {
          currentUser.addCombinedAction();
        }
    }
    notifyListeners();
  }

  /// removes the specified grip from the specified list type. Available types:
  /// - "Opposed"
  /// - "Unopposed"
  /// - "Combined"
  void removeGripFromUserList(String type, String actionName){
    switch(type){
      case "Opposed":
        currentUser.removeOpposedAction(actionName);
      case "Unopposed":
        currentUser.removeUnopposedAction(actionName);
      case "Combined":
        currentUser.removeCombinedAction(actionName);
    }
    notifyListeners();
  }

  RebelUser currentUser = AnonymousUser();

  /// returns access as index from the list [viewer, editor, clinician]
  int get userAccess{
    //options: viewer, editor, clinician
    switch (currentUser.accessType){
      case "clinician":
        return 2;
      case "editor":
        return 1;
      case "viewer":
        return 0;
      default:
        return 0;
    }
  }

  bool get useThumbToggling{
    return currentUser.useThumbToggling;
  }

  void toggleThumbTapUse(){
    currentUser.toggleThumbTap();
    notifyListeners();
  }

  void updateAction(String action, Grip? grip, Trigger? trigger){
    if(action == "direct"){
      currentUser.setDirectAction(trigger: trigger!, grip: grip);
    }
    else if(useThumbToggling){
      currentUser.setUnOpposedAction(action: action, grip: grip, trigger: trigger);
    }
    else {
      currentUser.setCombinedAction(action: action, grip: grip, trigger: trigger);
    }
    notifyListeners();
  }

  ///Available options:
  /// - "Signal A Range"
  /// - "Signal B Range"
  /// - "Signal A Gain"
  /// - "Signal B Gain"
  /// - "Switch Signals"
  dynamic getSignalSettings(String setting){
    switch(setting){
      case 'Signal A Range':
        return currentUser.signalSettings.signalArange;
      case 'Signal B Range':
        return currentUser.signalSettings.signalBrange;
      case 'Signal A Gain':
        return currentUser.signalSettings.signalAgain;
      case 'Signal B Gain':
        return currentUser.signalSettings.signalBgain;
      case 'Switch Signals':
        return currentUser.advancedSettings.switchInputs;
    }
  }

  ///Available options:
  ///       - "Signal A Range"
  ///       - "Signal B Range"
  ///       - "Signal A Gain"
  ///       - "Signal B Gain"
  ///       - "Switch Signals"
  void updateSignalSettings({required String setting, double primaryNewValue = -1, double secondaryNewValue = -1}){
    switch(setting){
      case 'Signal A Range':
        currentUser.signalSettings.setSignalArange(on: primaryNewValue, max: secondaryNewValue);
      case 'Signal B Range':
        currentUser.signalSettings.setSignalBrange(on: primaryNewValue, max: secondaryNewValue);
      case 'Signal A Gain':
        currentUser.signalSettings.signalAgain = primaryNewValue;
      case 'Signal B Gain':
        currentUser.signalSettings.signalBgain = primaryNewValue;
      case 'Switch Signals':
        currentUser.advancedSettings.switchInputs = !currentUser.advancedSettings.switchInputs;
    }
    notifyListeners();

  }
  //TODO: make this type of thing for the advanced settings as well?
  //#region ble commands
  void updateGripSettingsBle(String grip, String rule){
    //Todo: send the commands for updating grip settings
  }

  //#endregion

  //#region SQlite database
  void loadUserFromDB(BuildContext context, String username, String password) async{
    var tempUser = await _dbInterface.constructUserFromDb(context, username, password);
    if(tempUser!=null){
      currentUser = tempUser;
    }
    else{
      print("User $username could not be loaded");
    }
  }

  Future<bool> updateDb() async{
    return await _dbInterface.updateUserData(currentUser);
  }

  Future<List<String>> getAllSavedUsers() async{
    return await _dbInterface.getAllUserNames();
  }

  ///Attempt to load data for a given username,
  ///if username is not found the database then the previous User is kept
  void userLogIn(BuildContext context, String username, {String password = ""}) async{
    currentUser = await _dbInterface.constructUserFromDb(context, username, password) ?? currentUser;
  }

  /// create a new user profile
  Future<int> newUser({
    required String username,
    required bool saveCurrentSettings,
    String name = "", String password = "", String email = ""}) async{
    late RebelUser user ;
    if(saveCurrentSettings){
      user = RebelUser.copy(
          userName: username,
          copy: currentUser,
          name: name,
        password: password,
        email: email,
      );
    }
    else{
      user = RebelUser(username);
      user.name = name;
      user.password = password;
      user.email = email;
    }

    return await _dbInterface.newUserData(user);
  }

  ///A list of all usernames stored in the db
  List<String> userAccounts = [];
  ///Update the user accounts and notify listeners
  void updateUserAccounts() async{
    userAccounts = await _dbInterface.getAllUserNames();
    notifyListeners();
  }

  //#endregion


  @override
  void dispose() {
    super.dispose();
    print("General handler disposed");
  }

}