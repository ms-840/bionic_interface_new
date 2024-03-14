//The purpose of this class is to retain information about the user
// and their access status
// if no specific user is logged in, a generic/anonymous user profile should be used
// im also not sure yet how to best make the user log in
import 'package:bionic_interface/grip_trigger_action.dart';
import 'dart:math';

import 'package:flutter/material.dart';

class User{
  //constructor
  User(this.userName);

  User.fromDb({
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

  User.copy({
  required this.userName,
  required User copy,
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


}

class AnonymousUser extends User{
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

  // i am not sure yet how this should be used but it exists
  //bool switchInputs = false;
  //void switchSignalOrder(){
    //switchInputs = !switchInputs;
  //}

  SignalSettings({this.signalAon = 1, this.signalAmax = 3, this.signalBon = 1,
    this.signalBmax = 3, this.signalAgain = 1, this.signalBgain = 1});

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
}