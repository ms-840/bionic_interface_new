import 'dart:ffi';
import 'dart:math';

import 'package:bionic_interface/general_handler.dart';
import 'package:flutter/material.dart';
import 'package:bionic_interface/data_handling/data_handler.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import '../user/user.dart';

//TODO: this still needs editing

class DataPresentationPage extends StatefulWidget{
  const DataPresentationPage({super.key});

  @override
  State<DataPresentationPage> createState() => _DataPresentationPageState();
}


class _DataPresentationPageState extends State<DataPresentationPage>{
  //Things to change
  final limitCount = 100;

  //colors:
  late Color emg1Color;
  late Color emg2Color;

  //double emg1PlotScale = 1000;
  //double emg2PlotScale = 5000;
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
    dataHandler.startRandomDataGeneration();

  }


  late Widget doubleLineChartData;
  //bool showOneDataPlot = false; //false: show the data on two different plots


  @override
  Widget build(BuildContext context){
    emg1Color = Theme.of(context).colorScheme.secondary;
    emg2Color = Theme.of(context).colorScheme.primary;
      double max = 5; //TODO: this needs to be changed so it can be altered
      doubleLineChartData = listenableBuilder(liveDataLine(
          dataHandler.emg1DataToPlot.toList(growable: false),
          dataHandler.emg2DataToPlot.toList(growable: false),
          max,
      ));
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        appBar: AppBar(
          title: const Text("EMG Signals"),
          actions: [
            const SizedBox.shrink(),
            Image.asset('assets/images/logo.png', fit: BoxFit.contain, height: 50,),
            const SizedBox(width: 10,)
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //doubleLineChartData,
              SizedBox(
                height: 500,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,10),
                  child: rangeSlidersLayers(max, doubleLineChartData),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: trainingCircleRow(),
              ),
              AdvancedSettingsScreen(),
            ],
          ),
        ),

        /*
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

        )*/
    );
  }

  void openSettingsDialogue() async {
    final settings = await showDialog(
        context: context,
        builder: (context) => SettingsDialog(
          timeValue: dataHandler.timeLengthToPlot,
          //emg1Limits: emg1PlotScale,
          //emg2Limits: emg2PlotScale,
        )
    );
    //if data was passed along, change the settings
    // settings: [timeValue, emg2Limit, emg1Limit,]
    if(settings != null){
      dataHandler.setTimeLengthToPlot = settings[0];
      //emg2PlotScale = settings[1];
      //emg1PlotScale = settings[2];
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
        padding: const EdgeInsets.only(bottom: 25, top: 25, right: 0, left: 0),
        //top and bottom 25 seems to align the sliders with the data line quite well
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
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
  Widget thresholdSlider({
    required double max,
    required String sliderType})
  {
    final range = generalHandler.getSignalSettings(sliderType);
    //print(range);
    return SliderTheme(
      data: const SliderThemeData(
        minThumbSeparation: 0,
        inactiveTrackColor: Color(0x7F7F7F7F),
        rangeTrackShape: RoundedRectRangeSliderTrackShape(
        //I am not sure if there is really all that much i can do with this
        ),
        rangeThumbShape: RoundRangeSliderThumbShape(
          enabledThumbRadius: 1,
          disabledThumbRadius: 1,

        ),
      ),
      child: RangeSlider(
          activeColor: sliderType == "Signal A Range"? emg1Color:emg2Color,
          max: max,
          //divisions: max~/10,
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
      ),
    );
  }
  //#endregion


  //#training Circle
  //TODO: these values should not exist
  bool show = true;
  var status0 = 0;
  var status1 = 1;
  var status2 = 2;
  Widget trainingCircleRow(){
    //TODO: this is not properly hooked up yet
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 3 circles to test the triggers
        // one button to reset
        //const Text("Trigger Training: "),
        trainingCircle("Hold Open", status0),
        trainingCircle("Open Open", status1),
        trainingCircle("Co Con", status2),
        IconButton(
            onPressed: (){
              //TODO: this should send message back to the ble class to clear the trigger statuses
              setState(() {
                //TODO: This is temporary
                if(show){
                  status1 = 0;
                  status2 = 0;
                } else{
                  status1 = 1;
                  status2 = 2;
                }
                show = !show;
              });
            },
            icon: const Icon(Icons.refresh))
      ],
    );
  }

  Widget trainingCircle(String triggerName, int status){
    var grey = const Color(0xFF7F7F7F);
    var pink = Theme.of(context).colorScheme.secondary;
    var blue = Theme.of(context).colorScheme.primary;
    return Column(
      children: [
        Text(triggerName),
        Container(
          width: 30,
          height:  30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: status == 2 ? pink : status == 1? blue : grey,
          ),
        ),
      ],
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

class AdvancedSettingsScreen extends StatefulWidget{
  const AdvancedSettingsScreen({super.key});

  @override
  State<AdvancedSettingsScreen> createState() => _AdvancedSettingsState();
}

class _AdvancedSettingsState extends State<AdvancedSettingsScreen>{

  late GeneralHandler generalHandler;
  late AdvancedSettings advancedSettings;

  @override
  void initState(){
    //todo: initialize this by actually importing the settings
    generalHandler = Provider.of<GeneralHandler>(context, listen: false);
    advancedSettings = generalHandler.currentUser.advancedSettings;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ExpansionTile(
      title: const Text("Advanced Settings"),
      controlAffinity: ListTileControlAffinity.leading,
      children: [
        inputOptions(),
        advancedSettings.useTwoSignals? Container() :
        advancedSettings.alternate? singleSiteOptionsAlternate() : singleSiteOptionsFastClose(),
        triggerOptions(),
        notificationsOptions(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text("Hand Calibration"),
              IconButton(
                  onPressed: (){
                    Navigator.pushNamed(context, "/calibration");
                  },
                  icon: const Icon(Icons.settings))
            ],
          ),
        )
      ],
    );
  }

  Widget advancedSettingSpacer({required String title, required Widget settingWidget}){
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row( //Switch inputs
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(child: Text(title)),
          Expanded(
            child: settingWidget
          ),
        ],
      ),
    );
  }

  Widget advancedSettingSlider({required String title, required double value, required Function(double) onChanged,
    double min = 0, double max = 4, String unit = "sec", int decimals = 1}){
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 120,
              child: Text(title)),
          Expanded(child: Slider(
            value: value,
            onChanged: onChanged,
            min: min,
            max: max,
            divisions: ((max-min)*pow(10, decimals)).toInt(),
            label: "${value.toStringAsFixed(decimals)} $unit",
          )),
        ],
      ),
    );
  }

  Widget labeledSwitch({String trueLabel = "True", String falseLabel = "False", required bool value, required Function(bool)? onChanged}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(falseLabel),
        Switch.adaptive(
            value: value,
            onChanged: onChanged,
        ),
        Text(trueLabel),
      ],
    );
  }

  Widget inputOptions(){
    return ExpansionTile(
      title: const Text("Input Options"),
      controlAffinity: ListTileControlAffinity.leading,
      children: [
        advancedSettingSpacer(
            title: "Switch Inputs",
            settingWidget: labeledSwitch(
              value: advancedSettings.switchInputs,
              onChanged: (bool newValue){
                advancedSettings.switchInputs = newValue;
                setState(() {});
              },
              trueLabel: "BA",
              falseLabel: "AB",
            ),
        ),
        advancedSettingSpacer(
            title: "Input Type",
            settingWidget: labeledSwitch(
              value: advancedSettings.useTwoSignals,
              onChanged: (bool newValue){
                advancedSettings.useTwoSignals = newValue;
                setState(() {});
              },
              trueLabel: "2",
              falseLabel: "1",
            ),
        ),
      ],
    );
  }

  Widget triggerOptions(){
    return ExpansionTile(
      title: const Text("Trigger Options"),
      controlAffinity: ListTileControlAffinity.leading,
      children: [
        advancedSettingSlider(
            title: "Open Open Time",
            value: advancedSettings.timeOpenOpen,
            onChanged: (double newValue){
              advancedSettings.timeOpenOpen = newValue;
            },
          min: 0.1,
          max: 2,
        ),
        advancedSettingSlider(
          title: "Hold Open Time",
          value: advancedSettings.timeHoldOpen,
          onChanged: (double newValue){
            advancedSettings.timeHoldOpen = newValue;
          },
          min: 0.1,
          max: 2,
        ),
        advancedSettingSlider(
          title: "Co Con Time",
          value: advancedSettings.timeCoCon,
          onChanged: (double newValue){
            advancedSettings.timeCoCon = newValue;
          },
          min: 0.05,
          max: 0.25,
          decimals: 2
        ),
      ],
    );
  }

  Widget singleSiteOptionsAlternate(){
    return ExpansionTile(
      title: const Text("Single Site Options"),
      controlAffinity: ListTileControlAffinity.leading,
      children: [
        labeledSwitch(
            value: advancedSettings.alternate,
            onChanged: (bool newValue){
              advancedSettings.alternate = newValue;
              setState(() {});
            },
            trueLabel: "Alternating",
            falseLabel: "Fast/Close"
        ),
        advancedSettingSlider(
            title: "Alt Switch time",
            value: advancedSettings.timeAltSwitch,
            onChanged: (double newValue){
              advancedSettings.timeAltSwitch = newValue;
            },
            min: 0.1,
            max: 2,
        ),
      ],
    );
  }

  Widget singleSiteOptionsFastClose(){
    return ExpansionTile(
      title: const Text("Single Site Options"),
      controlAffinity: ListTileControlAffinity.leading,
      children: [
        labeledSwitch(
            value: advancedSettings.alternate,
            onChanged: (bool newValue){
              advancedSettings.alternate = newValue;
              setState(() {});
            },
            trueLabel: "Alternating",
            falseLabel: "Fast/Close"
        ),
        advancedSettingSlider(
          title: "Fast/Close time",
          value: advancedSettings.timeFastClose,
          onChanged: (double newValue){
            advancedSettings.timeFastClose = newValue;
          },
          min: 0.1,
          max: 2,
        ),
        advancedSettingSlider(
          title: "Fast/Close Level",
          value: advancedSettings.levelFastClose,
          onChanged: (double newValue){
            advancedSettings.levelFastClose = newValue;
          },
          min: 0.4,
          max: 4,
          unit: "V"
        ),

      ],
    );
  }

  Widget notificationsOptions(){
    return ExpansionTile(
      title: const Text("Notifications"),
      controlAffinity: ListTileControlAffinity.leading,
      children: [
        advancedSettingSpacer(
          title: "Vibrate",
          settingWidget: labeledSwitch(
            value: generalHandler.currentUser.advancedSettings.vibrate,
            onChanged: (bool newValue){
              generalHandler.currentUser.advancedSettings.vibrate = newValue;
              setState(() {});
            },
            trueLabel: "ON",
            falseLabel: "OFF",
          ),
        ),
        advancedSettingSpacer(
          title: "Buzzer",
          settingWidget: labeledSwitch(
            value: generalHandler.currentUser.advancedSettings.buzzer,
            onChanged: (bool newValue){
              generalHandler.currentUser.advancedSettings.buzzer = newValue;
              setState(() {});
            },
            trueLabel: "ON",
            falseLabel: "OFF",
          ),
        ),
      ],
    );
  }

}

class InputGains extends StatelessWidget{
  const InputGains({super.key});


  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text("Input Gains"),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("A"),
            Slider(
                value: 0,
                onChanged: (double newValue){
                  //TODO: fill this out
                  print("incomplete input gains");
                }
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("B"),
            Slider(
                value: 0,
                onChanged: (double newValue){
                  //TODO: fill this out
                  print("incomplete input gains");
                }
            ),
          ],
        ),
      ],
    );
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