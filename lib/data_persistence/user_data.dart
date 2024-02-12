import 'package:bionic_interface/user/user.dart';

import '../grip_trigger_action.dart';

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserDataSave{
  // general user data
  late int id;
  late String userName;
  late String name;
  late String password;
  late String email;
  late String accessType = "editor";

  //#region grip data
  //saved as a string in format "[grip1],[grip2],[...]"
  String combinedActions = "";
  String opposedActions = "";
  String unopposedActions = "";
  String directActions = ""; // format: "[trigger]:[grip],[trigger]:[grip]"

  //functions
  void convertActionToString({required Map<String, HandAction> combinedActionsSetting,
                              required Map<String, HandAction> unOpposedActionsSetting,
                              required Map<String, HandAction> directActionsSetting}){
    for(var value in combinedActionsSetting.values){
      combinedActions += value.gripName;
      combinedActions += ",";
    }

    for(var entry in unOpposedActionsSetting.entries){
      if(entry.key.contains("Unopposed")){
        unopposedActions += entry.value.gripName;
        unopposedActions += ",";
      }
      else{
        opposedActions += entry.value.gripName;
        opposedActions += ",";
      }
    }

    for(var entry in directActionsSetting.entries){
      directActions += "${entry.key}:${entry.value.triggerName},";
    }

  }

  Map<String, List<String>> convertStringToAction(){
    """
    This returns all of the actions in the right time
    Specifically only returns the combined, opposed, and unopposed actions
    """;
    final listCombinedAction = combinedActions.split(",");
    final listOpposedActions = opposedActions.split(",");
    final listUnopposedActions = unopposedActions.split(",");

    return {
      "Combined Actions": listCombinedAction.sublist(0,listCombinedAction.length-1),
      "Opposed Actions" : listOpposedActions.sublist(0, listOpposedActions.length-1),
      "Unopposed Actions":listUnopposedActions.sublist(0,listUnopposedActions.length-1)
    };


  }

  Map<String, String> convertStringToDirectAction(){
    List<String> listDirectActions = directActions.split(",");
    Map<String, String> directActionsMap = {};
    for(var action in listDirectActions.sublist(0,listDirectActions.length-1)){
      var dAction = action.split(":");
      directActionsMap[dAction[0]] = dAction[1];
    }
    return directActionsMap;
  }

  //#endregion

  //#region advanced settings
  late int switchInputs;
  late int useTwoSignals;
  late double inputGainA;
  late double inputGainB;

  late double timeOpenOpen;
  late double timeHoldOpen;
  late double timeCoCon;
  late int useThumbTrigger;

  late int alternate;
  late double timeAltSwitch;
  late double timeFastClose;
  late double levelFastClose;

  late int vibrate;
  late int buzzer;


  void convertAdvancedSettingToSimple(AdvancedSettings advancedSettings){
    switchInputs = advancedSettings.switchInputs? 1:0;
    useTwoSignals = advancedSettings.useTwoSignals? 1:0;
    inputGainA = advancedSettings.inputGainA;
    inputGainB = advancedSettings.inputGainB;

    timeOpenOpen = advancedSettings.timeOpenOpen;
    timeHoldOpen = advancedSettings.timeHoldOpen;
    timeCoCon = advancedSettings.timeCoCon;
    useThumbTrigger = advancedSettings.useThumbTrigger? 1:0;

    alternate = advancedSettings.alternate? 1:0;
    timeAltSwitch = advancedSettings.timeAltSwitch;
    timeFastClose = advancedSettings.timeFastClose;
    levelFastClose = advancedSettings.levelFastClose;

    vibrate = advancedSettings.vibrate? 1:0;
    buzzer = advancedSettings.buzzer? 1:0;
  }

  AdvancedSettings convertSimpleToAdvancedSetting(){
    return AdvancedSettings(
      switchInputs: switchInputs == 1? true:false,
      useTwoSignals: useTwoSignals == 1? true:false,
      inputGainA: inputGainA,
      inputGainB: inputGainB,

      timeOpenOpen: timeOpenOpen,
      timeHoldOpen: timeHoldOpen,
      timeCoCon: timeCoCon,
      useThumbTrigger: useThumbTrigger == 1? true:false,

      alternate: alternate == 1? true:false,
      timeAltSwitch: timeAltSwitch,
      timeFastClose: timeFastClose,
      levelFastClose: levelFastClose,

      vibrate: vibrate == 1? true:false,
      buzzer: buzzer == 1? true:false,
    );
  }

  //#endregion

  //#region signal settings
  late double signalAon;
  late double signalAmax;
  late double signalBon;
  late double signalBmax;

  late double signalAgain;
  late double signalBgain;

  void convertSignalSettingsToSimple(SignalSettings signalSettings){
    signalAon = signalSettings.signalAon;
    signalAmax = signalSettings.signalAmax;
    signalBon = signalSettings.signalBon;
    signalBmax = signalSettings.signalBmax;

    signalAgain = signalSettings.signalAgain;
    signalBgain = signalSettings.signalBgain;
  }

  SignalSettings convertSimpleToSignalSettings(){
    return SignalSettings(
      signalAon: signalAon,
      signalAmax: signalAmax,
      signalBon: signalBon,
      signalBmax: signalBmax,

      signalAgain: signalAgain,
      signalBgain: signalBgain,
    );
  }

  //#endregion
}