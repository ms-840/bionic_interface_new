import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HandCalibration extends StatefulWidget{
  const HandCalibration({super.key});

  @override
  State<StatefulWidget> createState() => _HandCalibrationState();
}
class _HandCalibrationState extends State<HandCalibration>{
  Map<String, double> handCalibrationOptions = {
    "F1 Open Pos" : 0,
    "F2 Open Pos" : 0,
    "F34 Open Pos" : 0,
    "Thumb Flex Open Pos" : 0,
    "Thumb Rot Open Pos" : 0,
    "F1 Tripod Target" : 0,
    "F2 Tripod Target" : 0,
    "TF Tripod Target" : 0,
    "TR Tripod Target" : 0,
  };

  @override
  void initState() {
    super.initState();
    //TODO: This should probably get information from the hand at this point,
    // i dont know if this should be classified as a user setting

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hand Calibration"),
        actions: [
          const SizedBox.shrink(),
          Image.asset('assets/images/logo.png', fit: BoxFit.contain, height: 50,),
          const SizedBox(width: 10,)
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for(var name in handCalibrationOptions.keys)
            calibrationSlider(name, handCalibrationOptions[name]!),
          ElevatedButton(
              onPressed: (){
                setState(() {
                  for(var name in handCalibrationOptions.keys){
                    handCalibrationOptions[name] = 0;
                  }
                });
              },
              child: const Text("Reset All"),
          ),
        ],
      ),
    );

  }

  Widget calibrationSlider(String calibrationName, double encoderPosition){
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 2, 15, 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(calibrationName),
          Expanded(child: Container()),
          IconButton(
              onPressed: (){
                var previous = handCalibrationOptions[calibrationName]!;
                setState(() {
                  handCalibrationOptions[calibrationName] = previous + 1;
                });
              },
              icon: const Icon(Icons.add)),
          Text(handCalibrationOptions[calibrationName].toString()),
          IconButton(
              onPressed: (){
                var previous = handCalibrationOptions[calibrationName]!;
                setState(() {
                  handCalibrationOptions[calibrationName] = previous - 1;
                });
              },
              icon: const Icon(Icons.remove)),
          const SizedBox(width: 20,),
          IconButton(
              onPressed: (){
                setState(() {
                  handCalibrationOptions[calibrationName] = 0;
                });
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
    );
  }

}