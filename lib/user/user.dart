//The purpose of this class is to retain information about the user
// and their access status
// if no specific user is logged in, a generic/anonymous user profile should be used
// im also not sure yet how to best make the user log in
import 'package:bionic_interface/grip_trigger_action.dart';

class User{
  //constructor
  User(this._userName, [this._adminAccess=false, this._childLock=false]);

  late final String _userName;
  String name = ""; //not sure if this is necessary
  bool _adminAccess = false;
  bool _childLock = false; //not sure yet if this is necessary


  Map<Grip,Trigger> _gripSettings = {}; //Format gripName:ruleName

  Map<String, HandAction> combinedActions = {
    "Next Grip" : HandAction(),
    "Grip 1" : HandAction(),
    "Grip 2" : HandAction(),
    "Grip 3" : HandAction(),
  };

  Map<String, HandAction> unOpposedActions = {
    "Next Grip" : HandAction(),
    "Opposed Grip 1" : HandAction(),
    "Opposed Grip 2" : HandAction(),
    "Opposed Grip 3" : HandAction(),
    "Unopposed Grip 1" : HandAction(),
    "Unopposed Grip 2" : HandAction(),
    "Unopposed Grip 3" : HandAction(),
  };

  bool useThumbToggling = true;
  Map<String,double> thresholdValues = {};
  //this could later include settings dictionary


  String get userName{
    return _userName;
  }

  bool get hasAdminAccess{
    return _adminAccess;
  }

  set adminAccess(bool adminAccess){
    _adminAccess = adminAccess;
  }

  bool get hasChildLock{
    return _childLock;
  }

  set childLock(bool childLock){
    _childLock = childLock;
  }

  Map<Grip,Trigger> get gripSettings{
    return _gripSettings;
  }

  Trigger ruleForGrip(Grip grip){
    final trigger = _gripSettings[grip];
    if(trigger!=null){
      return trigger;
    }
    return Trigger(name: "None", bleCommand: "0");
  }

  set importGripSettings (Map<Grip,Trigger> gripSettings){
    _gripSettings = gripSettings;
  }

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
        return trigger!;
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

  void updateGripSettings(Grip grip, Trigger trigger){
    _gripSettings[grip] = trigger;
  }

  void removeGripSetting(Grip grip){
    if(_gripSettings.containsKey(grip)){_gripSettings.remove(grip);}
  }

  void toggleThumbTap(){
    useThumbToggling = !useThumbToggling;
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



}

class AnonymousUser extends User{
  //This is the user class to be used when no login has occurred
  AnonymousUser() : super(''){
    print("Anonymous User created");
  }

  void clearUserData(){
    super._gripSettings.clear();
  }

}