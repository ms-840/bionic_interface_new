//The purpose of this class is to retain information about the user
// and their access status
// if no specific user is logged in, a generic/anonymous user profile should be used
// im also not sure yet how to best make the user log in
import 'package:bionic_interface/grip_trigger_action.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:bionic_interface/general_handler.dart';

import 'package:flutter/material.dart';

class RebelUser{
  //constructor
  RebelUser(this.userName);

  RebelUser.fromDb({
    required this.userName,
    required this.password,
    required this.name,
    required this.email,
    required this.accessType,

    required this.combinedActions,
    required this.unOpposedActions,
    required this.directActions,

    required this.advancedSettings,
    required this.signalSettings,
  });

  RebelUser.copy({
  required this.userName,
  required RebelUser copy,
    this.password = "",
    this.name = "",
    this.email = "",
    this.accessType = "editor",
  }){
    //not bothering with copying the maps for now since only one profile should be active at once
    combinedActions = copy.combinedActions;
    unOpposedActions = copy.unOpposedActions;
    directActions = copy.directActions;

    advancedSettings = copy.advancedSettings;
    signalSettings = copy.signalSettings;
  }

  late final String userName;
  String name = ""; //not sure if this is necessary
  String password = " ";
  String email = "";

  //todo: need to change access types to clinician, editor, viewer
  ///options: viewer, editor, clinician
  String accessType = "editor";

  SignalSettings signalSettings = SignalSettings();
  AdvancedSettings advancedSettings = AdvancedSettings();

  Map<String, HandAction> combinedActions = {
    //"Next Grip" : HandAction(),
    "Position 1" : HandAction(),
  };

  Map<String, HandAction> unOpposedActions = {
    //"Next Grip" : HandAction(),
    "Opposed Position 1" : HandAction(
      grip: Grip(name: "Power Grip",     type: "opposed",   bleCommand: "4", assetLocation: "assets/images/grips/power_grip.png")
    ),
    "Opposed Position 2" : HandAction(
        grip: Grip(name: "Tripod",         type: "opposed",   bleCommand: "7", assetLocation: "assets/images/grips/tripod.png")
    ),
    "Unopposed Position 1" : HandAction(
      grip: Grip(name: "Index Point",    type: "unopposed", bleCommand: "1", assetLocation: "assets/images/grips/index_point.png"),
    ),
    "Unopposed Position 2" : HandAction(
      grip: Grip(name: "Key",            type: "unopposed", bleCommand: "6", assetLocation: "assets/images/grips/lateral_key.png"),
    ),
  };

  Map<String, HandAction> directActions = { //to be used to actually assign the grips/actions to triggers
    //This should contain an entry for each of the triggers
    //I am not sure what would be best for the next grip action though, since i cant have a grip thats called next grip?
    "Open Open":    HandAction(trigger: Trigger(name: "Open Open",   bleCommand: "1", timeSetting: 0.2), grip: Grip(name: "Next Grip", type: "", bleCommand: "", assetLocation: "assets/images/logo_grey.png")),
    "Hold Open":    HandAction(trigger: Trigger(name: "Hold Open",   bleCommand: "2", timeSetting: 0.2)),
    "Co Con":       HandAction(trigger: Trigger(name: "Co Con",      bleCommand: "3", timeSetting: 0.25)),
    "Button Press": HandAction(trigger: Trigger(name: "Button Press",bleCommand: "4")),
  };

  bool get useThumbToggling {
    return advancedSettings.useThumbTrigger;
  }
  Map<String,double> thresholdValues = {};
  //this could later include settings dictionary

  /*
  String get userName{
    return _userName;
  }

  bool get hasAdminAccess{
    return _accessType == "clinician";
  }

  set adminAccess(String accessType){
    _accessType = accessType;
  }

   */

  void setCombinedAction({required String action, Grip? grip, Trigger? trigger}){
    combinedActions[action] = HandAction(grip: grip, trigger: trigger);
  }

  void setUnOpposedAction({required String action, Grip? grip, Trigger? trigger}){
    unOpposedActions[action] = HandAction(grip: grip, trigger: trigger);
  }

  Trigger triggerForAction(String action){
    Trigger? trigger;
    if(useThumbToggling){
      // use unOpposed action list
      try{
        trigger = unOpposedActions[action]!.trigger;
      } catch (e){
        return Trigger(name: "Error", bleCommand: "0");
      }

    }
    else{
      // use combined action list
      try{
        trigger = combinedActions[action]!.trigger;
      } catch (e){
        return Trigger(name: "Error", bleCommand: "0");
      }

    }
      if(trigger!=null){
        return trigger;
      }

    return Trigger(name: "None", bleCommand: "0");
  }

  Grip gripForAction(String action){
    Grip? grip;
    if(useThumbToggling){
      try{
        grip = unOpposedActions[action]!.grip;
      } catch (e){
        return Grip(name: "Error", type: "", bleCommand: "", assetLocation: "");
      }

    }
    else{
      try{
        grip = combinedActions[action]!.grip;
      } catch (e){
        return Grip(name: "Error", type: "", bleCommand: "", assetLocation: "");
      }

    }
    if(grip!=null){
      return grip;
    }
    return Grip(name: "None", type: "", bleCommand: "", assetLocation: "");
  }

  void toggleThumbTap(){
    advancedSettings.useThumbTrigger = !useThumbToggling;
  }

  Map<String, HandAction> get opposedActions{
    Map<String, HandAction> opposed = {};
    for(var action in unOpposedActions.keys){
      if(action.contains("Opposed")){
        opposed[action] = unOpposedActions[action]!;
      }
    }
    return opposed;
  }

  Map<String, HandAction> get unopposedActions{
    Map<String, HandAction> unopposed = {};
    for(var action in unOpposedActions.keys){
      if(action.contains("Unopposed")){
        unopposed[action] = unOpposedActions[action]!;
      }
    }
    return unopposed;
  }

  void addOpposedAction(){
    //this needs to find the highest number currently and add one one higher
    List<int> numberValues = [];
    for(var key in opposedActions.keys){
      try{
        var number = int.parse(key.split(" ")[2]);
        numberValues.add(number);
      }
      finally{
      }
    }
    var newNumber = numberValues.reduce(max) + 1;
    unOpposedActions["Opposed Position $newNumber"] = HandAction();
  }
  void addUnopposedAction(){
    List<int> numberValues = [];
    for(var key in unopposedActions.keys){
      try{
        var number = int.parse(key.split(" ")[2]);
        numberValues.add(number);
      }
      finally{
      }
    }
    var newNumber = numberValues.reduce(max) + 1;
    unOpposedActions["Unopposed Position $newNumber"] = HandAction();
  }
  void addCombinedAction(){
    List<int> numberValues = [];
    for(var key in combinedActions.keys){
      try{
        if(key == "Next Grip"){
          continue;
        }
        var number = int.parse(key.split(" ")[1]);
        numberValues.add(number);
      }
      finally{
      }
    }
    var newNumber = numberValues.reduce(max) + 1;
    combinedActions["Position $newNumber"] = HandAction();
  }

  void removeOpposedAction(String actionName){
    //identify the removed action
    // then remove the last action
    var removeActionNumber = int.parse(actionName.split(" ")[2]);
    List<int> numberValues = [];
    for(var key in opposedActions.keys){
      try{
        var number = int.parse(key.split(" ")[2]);
        numberValues.add(number);
      }
      finally{
      }
    }
    var currentMax = numberValues.reduce(max);
    var removeActionIndex = numberValues.indexOf(removeActionNumber);
    if(currentMax == 1){
      //If only one thing is left, it should not be removed. There should be at least one thing left
      return;
    }
    else if (removeActionNumber < currentMax){
      // if the number in the action is lower than the highest number, move the other actions up
      var keys = opposedActions.keys.toList();
      var values = opposedActions.values.toList();
      for(var i = removeActionIndex; i < keys.length - 1; i++) {
        // reassign the values to move them up
        unOpposedActions[keys[i]] = values[i + 1];
      }
    }
    unOpposedActions.remove("Opposed Position $currentMax");
  }
  void removeUnopposedAction(String actionName){
    //identify the removed action
    // then remove the last action
    var removeActionNumber = int.parse(actionName.split(" ")[2]);
    List<int> numberValues = [];
    for(var key in unopposedActions.keys){
      try{
        var number = int.parse(key.split(" ")[2]);
        numberValues.add(number);
      }
      finally{
      }
    }
    var currentMax = numberValues.reduce(max);
    var removeActionIndex = numberValues.indexOf(removeActionNumber);
    if(currentMax == 1){
      //If only one thing is left, it should not be removed. There should be at least one thing left
      return;
    }
    else if (removeActionNumber < currentMax){
      // if the number in the action is lower than the highest number, move the other actions up
      var keys = unopposedActions.keys.toList();
      var values = unopposedActions.values.toList();
      for(var i = removeActionIndex; i < keys.length - 1; i++) {
        // reassign the values to move them up
        unOpposedActions[keys[i]] = values[i + 1];
      }
    }
    unOpposedActions.remove("Unopposed Position $currentMax");
  }
  void removeCombinedAction(String actionName){
    //identify the removed action
    // then remove the last action
    var removeActionNumber = int.parse(actionName.split(" ")[2]);
    List<int> numberValues = [];
    for(var key in combinedActions.keys){
      try{
        var number = int.parse(key.split(" ")[2]);
        numberValues.add(number);
      }
      finally{
      }
    }
    var currentMax = numberValues.reduce(max);
    var removeActionIndex = numberValues.indexOf(removeActionNumber);
    if(currentMax == 1){
      //If only one thing is left, it should not be removed. There should be at least one thing left
      return;
    }
    else if (removeActionNumber < currentMax){
      // if the number in the action is lower than the highest number, move the other actions up
      var keys = combinedActions.keys.toList();
      var values = combinedActions.values.toList();
      for(var i = removeActionIndex; i < keys.length - 1; i++) {
        // reassign the values to move them up
        combinedActions[keys[i]] = values[i + 1];
      }
    }
    combinedActions.remove("Position $currentMax");
  }

  void setDirectAction({required Trigger trigger, Grip? grip}){
    directActions[trigger.name] = HandAction(trigger: trigger, grip: grip);
  }

  //#region to/from String conversion functions
    //#region convert to string
    /// Returns all set [combinedActions] as a comma deliminated string in the correct order
    String get combinedActionAsString{
      String combinedActionsString = "";
      for(var value in combinedActions.values){
        combinedActionsString += value.gripName;
        combinedActionsString += ",";
      }
      return combinedActionsString;
    }

    /// Returns all set [opposedActions] as a comma deliminated string in the correct order
    String get opposedActionAsString{
      String opposedActionsString = "";
      for(var value in opposedActions.values){
        opposedActionsString += value.gripName;
        opposedActionsString += ",";
      }
      return opposedActionsString;
    }

    /// Returns all set [unopposedActions] as a comma deliminated string in the correct order
    String get unopposedActionAsString{
      String unopposedActionsString = "";
      for(var value in unopposedActions.values){
        unopposedActionsString += value.gripName;
        unopposedActionsString += ",";
      }
      return unopposedActionsString;
    }

    /// Returns all set [unopposedActions] as a comma deliminated string in the correct order
    /// with the format "key:gripName,key2:gripName2,..."
    String  get directActionAsString{
      String directActionsString = "";
      for(var entry in directActions.entries){
        directActionsString += "${entry.key}:${entry.value.gripName},";
      }
      return directActionsString;
    }

    /// Returns all values held in the signal Settings as a
    Map<String,double> get signalSettingsAsMap{
      Map<String,double> signalSettingMap = {};
      signalSettingMap["signalAon"] = signalSettings.signalAon;
      signalSettingMap["signalAmax"] = signalSettings.signalAmax;
      signalSettingMap["signalBon"] = signalSettings.signalBon;
      signalSettingMap["signalBmax"] = signalSettings.signalBmax;
      signalSettingMap["signalAgain"] = signalSettings.signalAgain;
      signalSettingMap["signalBgain"] = signalSettings.signalBgain;

      return signalSettingMap;
    }
    //#endregion
    //#region convert to Flutter objects
    ///This returns all of the actions in the right time
    ///Specifically only returns the combined, opposed, and unopposed actions
    Map<String, HandAction>  convertStringToUnOpposedAction(
        Map<String, Grip> grips,
        String opposedActions,
        String unopposedActions,){

      final tempListOpposedActions = opposedActions.split(",");
      final tempListUnopposedActions = unopposedActions.split(",");
      final listOpposedActions = tempListOpposedActions.sublist(0, tempListOpposedActions.length-1);
      final listUnopposedActions = tempListUnopposedActions.sublist(0,tempListUnopposedActions.length-1);

      Map<String, HandAction> unOpposedActionsMap = {};

      for(var (index, action) in listOpposedActions.indexed){
        unOpposedActionsMap["Opposed Position ${index+1}"] = HandAction(grip: grips[action]);
      }
      for(var (index, action) in listUnopposedActions.indexed){
        unOpposedActionsMap["Unopposed Position ${index+1}"] = HandAction(grip: grips[action]);
      }

      return unOpposedActionsMap;
    }

    Map<String, HandAction> convertStringToCombinedAction(Map<String, Grip> grips, String combinedActions,){
      final tempListCombinedAction = combinedActions.split(",");
      // from the conversion, the last item in the string list is empty and must be removed
      final listCombinedAction = tempListCombinedAction.sublist(0,tempListCombinedAction.length-1);
      Map<String, HandAction> combinedActionsMap = {};
      for(var (index, action) in listCombinedAction.indexed){
        combinedActionsMap["Position ${index+1}"] = HandAction(grip: grips[action]);
      }
      return combinedActionsMap;
    }

    Map<String, HandAction> convertStringToDirectAction(Map<String, Grip> grips, Map<String, Trigger> triggers, String directActions){
      List<String> listDirectActions = directActions.split(",");
      Map<String, HandAction> directActionsMap = {};
      for(var action in listDirectActions.sublist(0,listDirectActions.length-1)){
        var dAction = action.split(":");
        directActionsMap[dAction[0]] = HandAction(
          trigger: triggers[dAction[0]],
          grip: grips[dAction[1]],
        );
      }
      return directActionsMap;
    }

    SignalSettings signalSettingsFromMap(Map<String,double> signalSettingsMap){
      return SignalSettings(
          signalAon: signalSettingsMap["signalAon"]!,
          signalAmax: signalSettingsMap["signalAmax"]!,
          signalBon: signalSettingsMap["signalBon"]!,
          signalBmax: signalSettingsMap["signalBmax"]!,
      );
    }
    //#endregion
  //#endregion

  ///Sets the following fields:
  /// - [unOpposedActions]
  /// - [combinedActions]
  /// - [directActions]
  /// - [signalSettings]
  /// - [advancedSettings]
  ///
  /// All new values should be given as strings, this method will deal with converting them to the relevant objects.
  ///
  /// This should primarily be used when syncing values from the firebase firestore
  void setAllSettings(GeneralHandler generalHandler,{
    required String newOpposedActions,
    required String newUnopposedActions,
    required String newDirectActions,
    required String newSignalSettings,
    required String newAdvancedSettings,
  }){

    unOpposedActions = convertStringToUnOpposedAction(
        generalHandler.gripPatterns, newOpposedActions, newUnopposedActions);
    directActions = convertStringToDirectAction(
        generalHandler.gripPatterns, generalHandler.triggers, newDirectActions);
    signalSettings = SignalSettings.fromString(newSignalSettings);
    advancedSettings = AdvancedSettings.fromString(newAdvancedSettings);
  }
}

class AnonymousUser extends RebelUser{
  //This is the user class to be used when no login has occurred
  AnonymousUser() : super(''){
    accessType = "viewer";
    //print("Anonymous User created");
  }


}

class SignalSettings {

  //This hopefully somewhat simplifies the user class, but may also be somewhat unnecessary
  late double signalAon;
  late double signalAmax;
  late double signalBon;
  late double signalBmax;

  double signalAgain = 1;
  double signalBgain = 1;

  SignalSettings({this.signalAon = 1, this.signalAmax = 3, this.signalBon = 1,
    this.signalBmax = 3, this.signalAgain = 1, this.signalBgain = 1});

  /// This can use a string formatted like a dictionary,
  /// like you would get from the toString() method for the class
  SignalSettings.fromString(String settingString){
    final variables = settingString.split(",");
    for(var entry in variables){
      var variable = entry.split(":")[0];
      switch (variable[0]){
        case "signalAon":
          signalAon = double.parse(variable[1]);
        case "signalAmax":
          signalAmax = double.parse(variable[1]);
        case "signalBon":
          signalBon = double.parse(variable[1]);
        case "signalBmax":
          signalBmax = double.parse(variable[1]);
        case "signalAgain":
          signalAgain = double.parse(variable[1]);
        case "signalBgain":
          signalBgain = double.parse(variable[1]);
      }
    }
  }

  RangeValues get signalArange{
    return RangeValues(signalAon,signalAmax);
  }
  RangeValues get signalBrange{
    return RangeValues(signalBon, signalBmax);
  }

  void setSignalArange({double on = -1, double max = -1}){
    if(on>max){
      //This should not be possible from the sliders, but just to be sure this is hard coded in as well
      on=max;
    }
    if(on >= 0){
      signalAon = on;
    }
    if(max >= 0){
      signalAmax = max;
    }
  }

  void setSignalBrange({double on = -1, double max = -1}){
    if(on>max){
      //This should not be possible from the sliders, but just to be sure this is hard coded in as well
      on=max;
    }
    if(on >= 0){
      signalBon = on;
    }
    if(max >= 0){
      signalBmax = max;
    }
  }

  @override
  String toString() {
    return "signalAOn:$signalAon,signalAmax:$signalAmax,signalBon:$signalBon,signalBmax:$signalBmax,signalAgain:$signalAgain,signalBgain:$signalBgain";
  }

}

class AdvancedSettings{
  //this should contain all of the data and settings which would be considered "Advanced Settings"
  //I kind of just want to access the values directly rather than wiht other methods, it seems silly

  AdvancedSettings({
    this.switchInputs = false,
    this.useTwoSignals = true,
    this.inputGainA = 1.0,
    this.inputGainB = 1.0,
    this.timeOpenOpen = 1.0,
    this.timeHoldOpen = 1.0,
    this.timeCoCon = 0.05,
    this.useThumbTrigger = true,
    this.alternate = false,
    this.timeAltSwitch = 1,
    this.timeFastClose = 1,
    this.levelFastClose = 1,
    this.vibrate = true,
    this.buzzer = true,
  });

  ///This constructs an advanced settings object from a string formatted like a dictionary,
  ///specifically the one that is made from the toString() method of this class
  AdvancedSettings.fromString(String settingString){
    final variables = settingString.split(",");
    for(var entry in variables){
      var variable = entry.split(":")[0];
      switch (variable[0]){
        case "switchInputs":
          switchInputs = variable[1] == "true";
        case "useTwoSignals":
          useTwoSignals = variable[1] == "true";
        case "inputGainA":
          inputGainA = double.parse(variable[1]);
        case "inputGainB":
          inputGainB = double.parse(variable[1]);
        case "timeOpenOpen":
          timeOpenOpen = double.parse(variable[1]);
        case "timeHoldOpen":
          timeHoldOpen = double.parse(variable[1]);
        case "timeCoCon":
          timeCoCon = double.parse(variable[1]);
        case "useThumbTrigger":
          useThumbTrigger = variable[1] == "true";
        case "alternate":
          alternate = variable[1] == "true";
        case "timeAltSwitch":
          timeAltSwitch = double.parse(variable[1]);
        case "timeFastClose":
          timeFastClose = double.parse(variable[1]);
        case "levelFastClose":
          levelFastClose = double.parse(variable[1]);
        case "vibrate":
          vibrate = variable[1] == "true";
        case "buzzer":
          buzzer = variable[1] == "true";
        }
      }
  }

  //input options
  bool switchInputs = false;
  bool useTwoSignals = true;
  double inputGainA = 1.0;
  double inputGainB = 1.0;

  List<double> get inputGain{
    """returns [inputGainA, inputGainB]""";
    return [inputGainA, inputGainB];
  }

  //trigger options
  double timeOpenOpen = 1.0; //range 0.2 - 2s
  double timeHoldOpen = 1.0; //range  0.2 - 2s
  double timeCoCon = 0.05; // range 0.05-0.25 s
  bool useThumbTrigger = true;

  //single site options
  bool alternate = false; //false = fast/close, true=alternate
  double timeAltSwitch = 1; //range 0.1 - 2s
  double timeFastClose = 1; //range 0.1 - 2s
  double levelFastClose = 1; //range 0.4 - 4V

  //notifications
  bool vibrate = true;
  bool buzzer = true;

  List<bool> get notifications{
    return [vibrate, buzzer];
  }

  @override
  String toString(){
    return "switchInputs:$switchInputs,"
           "useTwoSignals:$useTwoSignals,"
           "inputGainA:$inputGainA,"
           "timeOpenOpen:$timeOpenOpen,"
           "timeHoldOpen:$timeHoldOpen,"
           "timeCoCon:$timeCoCon,"
           "useThumbTrigger:$useThumbTrigger,"
           "alternate:$alternate,"
           "timeAltSwitch:$timeAltSwitch,"
           "timeFastClose:$timeFastClose,"
           "levelFastClose:$levelFastClose,"
           "vibrate:$vibrate,"
           "buzzer:$buzzer";
  }
}