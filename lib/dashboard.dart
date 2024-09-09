import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:iot_app/appbar.dart';
import 'package:iot_app/charts/humidity_chart.dart';
import 'package:iot_app/charts/moisture_chart.dart';
import 'package:iot_app/charts/temp_chart.dart';
import 'package:iot_app/drawer.dart';

class Dashboard extends StatefulWidget {
  final String? currentScreen;

  const Dashboard({Key? key, this.currentScreen}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<dynamic> temperatureData = [];
  List<dynamic> humidityData = [];
  List<dynamic> filteredTemperatureData = [];
  List<dynamic> filteredHumidityData = [];
  double maxTempFixed = 100;
  double minTempFixed = 0;
  double maxHumidity = 100;
  double minHumidity = 0;

  double avgTemp = 32;
  double avgHum = 67;
  double avgMois = 30;

  Color primaryColor = Color.fromARGB(255, 21, 28, 47);
  Color secondaryColor = Color.fromARGB(255, 32, 50, 77);
  Color tertiaryColor = Color.fromARGB(255, 37, 213, 179);

  final List<Map<String, dynamic>> _options = [
    {
      'Weed Garden': {
        "avgTemp" : 32.0,
        "avgHum" : 67.0,
        "avgMois" : 30.0,
      }
    },{
      'Asia Park': {
        "avgTemp" : 27.0,
        "avgHum" : 54.0,
        "avgMois" : 28.0,
      }
    },{
      'Long Cloud': {
        "avgTemp" : 37.0,
        "avgHum" : 62.0,
        "avgMois" : 35.0,
      }
    },
  ];

  String _selectedOption = 'Weed Garden';
  List<String> keys = [];

  @override
  void initState() {
    super.initState();
    keys = _options.map((item) => item.keys.first).toList();
      keys.forEach((_element)=>{
        print(_element)
      });
  }


  void changeData() {
    // Find the selected option in the _options list
    final selectedMap = _options.firstWhere(
          (item) => item.containsKey(_selectedOption),
      orElse: () => {},
    );

    // If the selectedMap is found and not empty, update the values
    if (selectedMap.isNotEmpty) {
      setState(() {
        avgTemp = selectedMap[_selectedOption]["avgTemp"];
        avgHum = selectedMap[_selectedOption]["avgHum"];
        avgMois = selectedMap[_selectedOption]["avgMois"];
      });
    }
  }


  Widget GeneralCard({
    IconData icon = Icons.question_mark,
    required double width,
    required double height,
    required String average,
    required String label,
    required double percentage,
    required ThemeData theme
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: theme.cardColor,
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      width: width,
      height: height,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Icon(
              icon,
              color: theme.colorScheme.secondary,
              size: 42,
            ),
            SizedBox(height: 16.0),
            Text(
              average,
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontSize: 24.0,
              ),
            ),
          ],
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 120,
              width: 120,
              child: CircularProgressIndicator(
                value: percentage * 0.01,
                strokeWidth: 8.0,
                color: theme.colorScheme.secondary,
                backgroundColor: Color.fromARGB(255, 81, 91, 193).withOpacity(0.6),
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: MainDrawer(currentScreen: 'Dashboard'),
      appBar: MainAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Transform.translate(
            offset: Offset(0, -10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text(
                        "IoT System",
                        style: TextStyle(
                            color: theme.textTheme.bodyMedium?.color,
                            fontSize: 36),
                      ),
                      Row(
                        children: [
                          Text("Welcome to your ",style: TextStyle(fontSize: 16, color: theme.colorScheme.secondary),),
                          DropdownMenu<String>(
                            trailingIcon: Icon(Icons.add, size: 0,),
                            selectedTrailingIcon: Icon(Icons.add, size: 0,),
                            onSelected: (String? newValue) {
                              setState(() {
                                _selectedOption = newValue!;
                                changeData();
                              });
                            },
                            inputDecorationTheme: InputDecorationTheme(
                              constraints: BoxConstraints(
                                maxHeight: 46,
                              ),
                              contentPadding: EdgeInsets.all(0),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,),
                              ),
                            ),
                            initialSelection: _selectedOption,
                            dropdownMenuEntries: keys.map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                value: value,
                                label: value,
                              );
                            }).toList(),
                            menuStyle: MenuStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  theme.cardColor), // secondary color
                              shadowColor: WidgetStateProperty.all(
                                  theme.cardColor.withOpacity(0.2)), // tertiary color
                            ),
                            textStyle: TextStyle(color: theme.colorScheme.onPrimary,fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const TempChart(),
                    ));
                  },
                  child: GeneralCard(
                    icon: Icons.thermostat,
                    height: 180,
                    width: screenWidth,
                    label: "Temperature",
                    average: "$avgTemp°C",
                    percentage: avgTemp*1.15,
                    theme: theme,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const HumidityChart(),
                    ));
                  },
                  child: GeneralCard(
                    icon: Icons.water_drop_outlined,
                    height: 180,
                    width: screenWidth,
                    label: "Humidity",
                    average: "$avgHum%",
                    percentage: (avgHum*0.9),
                    theme: theme,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const MoistureChart(),
                    ));
                  },
                  child: GeneralCard(
                    icon: Icons.opacity,
                    height: 180,
                    width: screenWidth,
                    label: "Moisture",
                    average: "$avgMois%",
                    percentage: avgMois*1.123,
                    theme: theme,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
