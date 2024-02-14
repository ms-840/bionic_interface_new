import 'package:bionic_interface/user/user.dart';
import 'package:drift/drift.dart';

import '../grip_trigger_action.dart';

import 'dart:async';
import 'package:path/path.dart';


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

class UserDataEntity extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userName => text().named("user_name")();
  TextColumn get name => text().named("name")();
  TextColumn get password => text().named("password")();
  TextColumn get email => text().named("email")();
  TextColumn get accessType => text().named("accessType")();

  //Grip data
  TextColumn get combinedActions => text().named("combined_actions")();
  TextColumn get opposedActions => text().named("opposed_actions")();
  TextColumn get unopposedActions => text().named("unopposed_actions")();
  TextColumn get directActions => text().named("direct_actions")();

  //advanced settings
  BoolColumn get switchInputs => boolean().named("switch_inputs")();
  BoolColumn get useTwoSignals => boolean().named("use_two_signals")();
  RealColumn get inputGainA => real().named("input_gain_a")();
  RealColumn get inputGainB => real().named("input_gain_b")();

  BoolColumn get useThumbTrigger => boolean().named("use_thumb_trigger")();
  RealColumn get timeOpenOpen => real().named("time_open_open")();
  RealColumn get timeHoldOpen => real().named("time_hold_open")();
  RealColumn get timeCoCon => real().named("time_co_con")();


  BoolColumn get alternate => boolean().named("alternate")();
  RealColumn get timeAltSwitch => real().named("time_alt_switch")();
  RealColumn get timeFastClose => real().named("time_fast_close")();
  RealColumn get levelFastClose => real().named("level_fast_close")();

  BoolColumn get vibrate => boolean().named("vibrate")();
  BoolColumn get buzzer => boolean().named("buzzer")();

  //signal settings
  RealColumn get signalAon => real().named("signal_a_on")();
  RealColumn get signalAmax => real().named("signal_a_max")();
  RealColumn get signalBon => real().named("signal_b_on")();
  RealColumn get signalBmax => real().named("signal_b_max")();

  RealColumn get signalAgain => real().named("signal_a_gain")();
  RealColumn get signalBgain => real().named("signal_b_gain")();
}