import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class DataGenerator{
  //This should especially be kept in its own class to allow easier substitution when BLE is added

  DataGenerator({required this.samplingRate});

  double xValue = 0;
  late double samplingRate;
  late double xStep = 1/samplingRate;

  int animationState = 3;
  double yMax = 1; // This is just to make trying stuff out easier, can be changed

  void incrementAnimationState(int increment){
    animationState += increment;
  }

  FlSpot generatedData(){
    FlSpot newDataPoint;

    // Currently this can switch between 3 different data modes for testing
    if(animationState == 0) {
      newDataPoint = FlSpot(xValue, Random().nextDouble() * yMax);
    } else if(animationState == 1) {
      newDataPoint = FlSpot(xValue, xValue % yMax);
    } else if(animationState == 2){
      newDataPoint = FlSpot(xValue, sin(5*xValue)+1);
    } else {
      // to be used to test the triggering code
      newDataPoint = FlSpot(xValue, xValue%50==0? Random().nextDouble()*0.3 : 1);
    }
    xValue += xStep;
    return newDataPoint;
  }

  void setXtoZero(){
    xValue = 0;
  }


  List<double> generateDataForDataHandler(){
    double ecgValue;
    double mcgValue = Random().nextDouble();

    if(animationState == 0) {
      ecgValue = Random().nextDouble();
    } else if(animationState == 1) {
      ecgValue = xValue % yMax;
    } else if (animationState == 2){
      ecgValue = sin(5*xValue)+1;
      mcgValue = cos(5*xValue)+1;
    } else{
      // to be used for triggering, spikes happen every second
      ecgValue = xValue%1<0.005? 1: Random().nextDouble()*0.3;
      mcgValue = xValue%1<0.005? 1: Random().nextDouble()*0.3;
    }
    // it should be [time, ECG, MCG]
    final ret = [xValue, ecgValue, mcgValue];
    xValue+=xStep;
    return ret;
  }
}