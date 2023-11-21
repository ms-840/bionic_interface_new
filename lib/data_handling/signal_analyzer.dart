//this should hold the signal analyzer, a class which has mechanisms for
// getting data from the data handler and using that to calculate
// threshold and max values from the emg

import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SignalAnalyzer{
  double thresholdCoefficient = 2;

  SignalAnalyzer([this.thresholdCoefficient = 2]);



  Map<String,double> _calculateNewValues(List<FlSpot> emgData){
    """ Calculate new values for Max and Threshold from EMG data """;
    //Todo: figrue out exactly what values i need

    final processingData = _extractDataFromFlSpot(emgData);
    var signalMean = processingData.reduce((a, b) => a + b) / processingData.length;
    var signalSTD = sqrt(processingData.map((x) => pow(x - signalMean, 2)).reduce((a, b) => a + b) /
        (processingData.length));
    var threshold = signalMean + thresholdCoefficient*signalSTD;

    //Todo: apply max and threshold data calculation
    //ensure max>threshold

    // values to return: max, threshold
    return {};
  }

  List<double> _extractDataFromFlSpot(List<FlSpot> emgData){
    return emgData.map((point) => point.y).toList();
  }

}