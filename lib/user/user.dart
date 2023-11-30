//The purpose of this class is to retain information about the user
// and their access status
// if no specific user is logged in, a generic/anonymous user profile should be used
// im also not sure yet how to best make the user log in
import 'package:bionic_interface/grips.dart';

class User{
  late final String _userName;
  String name = ""; //not sure if this is necessary
  bool _adminAccess = false;
  bool _childLock = false; //not sure yet if this is necessary
  Map<Grip,Trigger> _gripSettings = {}; //Format gripName:ruleName
  Map<String,double> thresholdValues = {};
  //this could later include settings dictionary

  //#region getters and setters
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


  //#endregion

  //constructor
  User(this._userName, [this._adminAccess=false, this._childLock=false]);

  void updateGripSettings(Grip grip, Trigger trigger){
    _gripSettings[grip] = trigger;
  }

  void removeGripSetting(Grip grip){
    if(_gripSettings.containsKey(grip)){_gripSettings.remove(grip);}
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