import 'ble_interface.dart';
import 'data_generator.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'dart:async';


class DataHandler extends ChangeNotifier{
  //this class should be in charge of passing data
  // Specifically the things it should do:
  //  - generate data while there is nothing that actually sends data
  //  - once we have something actually measuring data, dealing with passing that to other classes

  final double samplingRate = 100;//should be samples per second

  late BleInterface bleInterface;



  DataHandler(this.bleInterface);


  //#region Methods and other data used for plotting

  //Exposing the plottable data
  // TODO: it may be better to specify the length of the list, may reduce computational resources
  // may be a bit more difficult to shift the data around though
  // currently it works as is, if performance optimization is necessary re-address this (maybe queues)
  //TODO: replace with listqueues
  List<FlSpot> emg1DataToPlot = [const FlSpot(0, 0)];
  List<FlSpot> emg2DataToPlot = [const FlSpot(0, 0)];


  int _dataLengthToPlot = 2000; //current sampling rate: 640
  double get timeLengthToPlot => _dataLengthToPlot / samplingRate;
  set setTimeLengthToPlot(double timeLength){
    _dataLengthToPlot = (timeLength*samplingRate).toInt();
  }

  void clearPlottingData(){
    emg1DataToPlot = [const FlSpot(0, 0)];
    emg2DataToPlot = [const FlSpot(0, 0)];
  }

  void updatePlottingData(List<FlSpot> newEmg1Data, List<FlSpot> newEmg2Data){
    /// insert new data, remove as many old data, notify listener
    emg1DataToPlot.addAll(newEmg1Data);
    emg2DataToPlot.addAll(newEmg2Data);

    while (emg1DataToPlot.length > _dataLengthToPlot) {
      emg1DataToPlot.removeAt(0);
    }
    while (emg2DataToPlot.length > _dataLengthToPlot){
      emg2DataToPlot.removeAt(0);
    }

    notifyListeners();
  }
  //#endregion


  //#region Functions to help pass the data from the ble device to plotting
  StreamController bleStreamController = StreamController();
  double currentTimeE = 0;
  double currentTimeM = 0;

  void incrementTime(String identifier){
    if(identifier == "E"){
      currentTimeE += 1/samplingRate;
    }
    else if(identifier == "M"){
      currentTimeM += 1/samplingRate;
    }
    else{
      print("Data Handler: incrementing time not possible: identifier not correct");
    }
  }

  void setTimeBackToZero(){
    currentTimeE = 0;
    currentTimeM = 0;
  }

  late Timer dataTransferTimer;




  void startDataTransfer()async{
    setTimeBackToZero();
     // ensures that the ble disconnection happens properly
    bleInterface.subscribeToCharacteristic();
    final duration = (1/samplingRate*1000).toInt(); //it should try to do this more often than it receives data
    //5 ms for a sampling rate of 200

    dataTransferTimer = Timer.periodic(Duration(milliseconds: duration), (timer){
      if(bleInterface.receivedDataBuffer.initialFillingComplete
          && bleInterface.receivedDataBuffer.getBufferLength() > 0){
        extractBLEdata();
      }else{
        //print("Data not ready to transfer");
      }
    });

  }

  void cancelDataTransfer(){
    bleInterface.unsubscribeFromCharacteristic();
    dataTransferTimer.cancel();
  }
  void disconnectBLE(){
    bleInterface.disconnect();
  }

  void extractBLEdata(){
    var newData = bleInterface.receivedDataBuffer.removeFromBuffer();
    bleInterface.checkDataIsComplete(newData);

    //TODO: get new ble protocols for ble communication

  }

  double convert2ByteToDouble(int highByte, int lowByte){
    //This is not the most efficient way of doing this
    var highHex = highByte.toRadixString(16);
    var lowHex = lowByte.toRadixString(16);
    if(lowHex.length == 1){
      lowHex = "0$lowHex";
    }
    var intValue = int.parse(highHex+lowHex, radix: 16);
    if(intValue>32767){
      //make it signed
      intValue-=65536;
    }
    return intValue.toDouble();


  }

  late DataGenerator dataGenerator;

  void startRandomDataGeneration(){
    dataGenerator = DataGenerator(samplingRate: samplingRate);
    final duration = (1/samplingRate*1000).toInt();

    dataTransferTimer = Timer.periodic(Duration(milliseconds: duration), (timer){
      var newdata = dataGenerator.generateDataForDataHandler();
      updatePlottingData([FlSpot(newdata[0], newdata[1])], [FlSpot(newdata[0], newdata[2])]);
      print(newdata);
    });
  }
//#endregion
}