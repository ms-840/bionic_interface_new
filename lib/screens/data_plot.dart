import 'dart:ffi';

import 'package:bionic_interface/general_handler.dart';
import 'package:flutter/material.dart';
import 'package:bionic_interface/data_handling/data_handler.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

//TODO: this still needs editing

class DataPresentationPage extends StatefulWidget{
  const DataPresentationPage({super.key});

  @override
  State<DataPresentationPage> createState() => _DataPresentationPageState();
}


class _DataPresentationPageState extends State<DataPresentationPage>{
  //Things to change
  final limitCount = 500;

  //colors:
  final Color emg1Color = Colors.deepOrange;
  final Color emg2Color = Colors.indigo;

  double emg1PlotScale = 1000;
  double emg2PlotScale = 5000;
  bool showOnePlot = false;

  late DataHandler dataHandler;
  late GeneralHandler generalHandler;

  @override
  void initState() {
    super.initState();
    generalHandler = Provider.of<GeneralHandler>(context, listen: false);
    dataHandler = Provider.of<DataHandler>(context, listen: false);
    dataHandler.clearPlottingData();
    setState(() {});
    //Turn on for ble data transfer
    dataHandler.startDataTransfer();
  }


  late Widget doubleLineChartData;
  //bool showOneDataPlot = false; //false: show the data on two different plots


  @override
  Widget build(BuildContext context){
      double max = 1000; //TODO: this needs to be changed so it can be altered
      doubleLineChartData = listenableBuilder(liveDataLine(
          dataHandler.emg1DataToPlot.toList(growable: false),
          dataHandler.emg2DataToPlot.toList(growable: false),
          max,
      ));
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 15),
              child: Image.asset('assets/images/logo.png', fit: BoxFit.contain, height: 30,),
            ),
            //doubleLineChartData,
            Padding(
              padding: const EdgeInsets.fromLTRB(0,50,0,15),
              child: rangeSlidersLayers(max, doubleLineChartData),
            ),
            /*Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  stackLineAndSliders(
                      dataLine: doubleLineChartData,
                      sliders: const Icon(Icons.ac_unit),
                      //sliders: rangeSlidersLayers(max),
                  ),
                  //ElevatedButton(onPressed: (){setState(() {showLiveData = !showLiveData;});}, child: Text("Change Data Presentation")),
                ],
              ),
            ),
            */
          ],
        ),

        floatingActionButton: PopupMenuButton<String>(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: "back",
              onTap: (){
                Navigator.pop(context);
              },
              child: const ListTile(
                leading: Icon(Icons.arrow_back_ios_new),
                title: Text("Back"),
              ),
            ),
            PopupMenuItem(
              value: "settings",
              onTap: (){
                openSettingsDialogue();
              },
              child: const ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
              ),
            ),
            PopupMenuItem(
              value: "commands",
              onTap: () async{
                var settings = await Navigator.pushNamed(context,"/commands");
                if(settings != null){
                  Navigator.pop(context);
                }
              },
              child: const ListTile(
                leading: Icon(Icons.settings_remote),
                title: Text("Configure Board"),
              ),)
          ],
          icon: const Icon(Icons.arrow_drop_down),

        )
    );
  }

  void openSettingsDialogue() async {
    final settings = await showDialog(
        context: context,
        builder: (context) => SettingsDialog(
          timeValue: dataHandler.timeLengthToPlot,
          emg1Limits: emg1PlotScale,
          emg2Limits: emg2PlotScale,
        )
    );
    //if data was passed along, change the settings
    // settings: [timeValue, emg2Limit, emg1Limit,]
    if(settings != null){
      dataHandler.setTimeLengthToPlot = settings[0];
      emg2PlotScale = settings[1];
      emg1PlotScale = settings[2];
    }

  }

  //#region Data Lines
  //Standardizing plot formatting
  LineChartBarData dataLine(List<FlSpot> points, Color color){
    return LineChartBarData(
      spots: points,
      dotData: const FlDotData(
        show: false,
      ),
      color: color,
      barWidth: 2,
      isCurved: false,
    );

  }

  //To allow easier transfer of data
  ListenableBuilder listenableBuilder(Widget widget){
    return ListenableBuilder(
      listenable: Provider.of<DataHandler>(context),
      builder: (BuildContext context, Widget? child){
        return widget;
      },
    );
  }

  //Defining the different plots
  Expanded liveDataLine(List<FlSpot> aData, List<FlSpot> bData, double max){
    RangeValues rangeA = generalHandler.getSignalSettings("Signal A Range");
    RangeValues rangeB = generalHandler.getSignalSettings("Signal B Range");
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15, top: 15, right: 0, left: 0),
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: max,
            minX: aData.first.x,
            maxX: bData.last.x,
            lineTouchData: const LineTouchData(enabled: true), // presumably can be used to control how touch is handled by the app
            clipData: const FlClipData.all(),
            gridData: const FlGridData(
              show: true,
              drawVerticalLine: false,
            ),
            borderData: FlBorderData(show: true),
            extraLinesData: ExtraLinesData(
              horizontalLines: [
                HorizontalLine(y: rangeA.start, color: emg1Color),
                HorizontalLine(y: rangeA.end, color: emg1Color),
                HorizontalLine(y: rangeB.start, color: emg2Color),
                HorizontalLine(y: rangeB.end, color: emg2Color),
              ]
            ),
            lineBarsData: [
              dataLine(aData, emg1Color),
              dataLine(bData, emg2Color)
            ],
            titlesData: const FlTitlesData(
              show: true,
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              /*
              bottomTitles: const AxisTitles(
                  axisNameWidget: Text("Time (s)"),
                  sideTitles: SideTitles(interval: 1, showTitles: true, reservedSize: 40,)
              ),
              leftTitles: AxisTitles(
                axisNameWidget: const Text("emg2 (uV)"),
                sideTitles: SideTitles(interval: emg2PlotScale/2, showTitles: true, reservedSize: 40,),
              ),

               */
            ),
          ),
          duration: const Duration(milliseconds: 0), //This is necessary to prevent the weird fluttering in the data

        ),
      ),
    );
  }

  Widget stackLineAndSliders({required Widget dataLine, required Widget sliders}){
    return Stack(
      children: [
        dataLine,
        sliders
      ],
    );
  }

  Widget rangeSlidersLayers(double max, Widget dataLine){
    return Row(
      children: [
        RotatedBox(
          quarterTurns: 3,
          child: thresholdSlider(
              sliderType: "Signal A Range",
              max: max,),
        ),
        dataLine,
        RotatedBox(
          quarterTurns: 3,
          child: thresholdSlider(
            sliderType: "Signal B Range",
            max: max,),
        ),
      ],
    );
  }
  RangeSlider thresholdSlider({
    required double max,
    required String sliderType}){
    final range = generalHandler.getSignalSettings(sliderType);
    //print(range);
    return RangeSlider(
        max: max,
        divisions: max~/10,
        //labels: RangeLabels(range.start.toString(), range.end.toString(),),
        values: range,
        onChanged: (RangeValues values){
          //update the values in the user settings
          setState(() {
            generalHandler.updateSignalSettings(
                setting: sliderType,
                primaryNewValue: values.start,
                secondaryNewValue: values.end
            );
          });
          //print("New values: ${values.start}, ${values.end}");
        }
    );
  }
  //#endregion

  @override
  void didChangeDependencies() {
    dataHandler = Provider.of<DataHandler>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //Uncomment for automatic data generation
    //print("trying to dispose of state");
    dataHandler.cancelDataTransfer();
    dataHandler.disconnectBLE();
    super.dispose();
  }
}

class SettingsDialog extends StatefulWidget{
  final double timeValue;

  final double emg2Limits;
  final double emg1Limits;
  
  
  const SettingsDialog({super.key,
    required this.timeValue,
    this.emg2Limits = 1000,
    this.emg1Limits = 1000,
  });

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog>{
  late double _timeValue;

  late double _emg2Limits;
  late double _emg1Limits;

  final _emg1LimitsController = TextEditingController();
  final _emg2LimitsController = TextEditingController();


  @override
  void initState(){
    super.initState();
    _timeValue = widget.timeValue;
    _emg2Limits = widget.emg2Limits;
    _emg1Limits = widget.emg1Limits;
  }

  @override
  Widget build(BuildContext context){
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Settings",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 8),
              const Text(
                "Change Time Window",
              ),
              Slider(
                value: _timeValue,
                //this should be taken from the data handler
                max: 10,
                min: 1,
                divisions: 19,
                label: "${_timeValue.round().toString()} sec",
                onChanged: (double value) {
                  setState(() {
                    _timeValue = value;
                  });
                },
              ),
              TextField(
                controller: _emg1LimitsController,
                decoration: const InputDecoration(labelText: "EMG 1 Limit"),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onSubmitted: (String newText){
                  if(newText.isEmpty){
                    _emg1LimitsController.text = _emg1Limits.toString();
                  }
                },
              ),
              TextField(
                controller: _emg2LimitsController,
                decoration: const InputDecoration(labelText: "EMG 2 Limit"),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onSubmitted: (String newText){
                  if(newText.isEmpty){
                    _emg2LimitsController.text = _emg2Limits.toString();
                  }
                },
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: (){
                        //do not update the time window
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                  TextButton(
                    onPressed: (){
                      //update the values
                      if(_emg1LimitsController.text.isEmpty){
                        _emg1LimitsController.text = _emg1Limits.toString();
                      }
                      if(_emg2LimitsController.text.isEmpty){
                        _emg2LimitsController.text = _emg2Limits.toString();
                      }
                      _emg1Limits = double.parse(_emg1LimitsController.text).abs();
                      _emg2Limits = double.parse(_emg2LimitsController.text).abs();

                      Navigator.pop(context, [_timeValue, _emg2Limits, _emg1Limits,]);
                    },
                    child: const Text("OK"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}