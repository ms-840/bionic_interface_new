// this should hold the classes for both grip patterns and grip triggers

class Grip{
  late String name;
  late String type; //Type can be opposed or unopposed
  late String bleCommand;
  late String description;
  late String assetLocation;

  Grip({
    required this.name,
    required this.type,
    required this.bleCommand,
    required this.assetLocation
  });

}

class Trigger{
  late String name;
  late String bleCommand;
  late double timeSetting;
  late String description;
  late String assetLocation;

  Trigger({required this.name, required this.bleCommand, this.timeSetting = 0});

  set time(double newTime){
    timeSetting = newTime;
  }
}

class HandAction{
  //This is somewhat multi purpose now, also to hold grips and/or triggers without having to be paired up necessarily
  late Grip? grip;
  late Trigger? trigger;

  HandAction({this.grip, this.trigger});

  String get gripName{
    if(grip!=null){
      return grip!.name;
    }
    return "None";
  }
  String get triggerName{
    if(trigger!=null){
      return trigger!.name;
    }
    return "None";
  }

}