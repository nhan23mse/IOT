import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:iot_app/api/humidity_repo.dart';
import 'package:iot_app/api/sensors_repo.dart';
import 'package:iot_app/charts/legend.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HumidityChart extends StatefulWidget {
  const HumidityChart({super.key});

  @override
  State<HumidityChart> createState() => _HumidityChartState();
}

class _HumidityChartState extends State<HumidityChart> {

  late List<Map<String, dynamic>> data = [];
  late Map<String,dynamic> humidity = {};
  late Map<String,dynamic> minimum = {};
  late Map<String,dynamic> maximum = {};


  Future<void> getHumidity() async {
    List<dynamic> res = await HumidityRepo.getHumidityChart(1);
    setState(() {
      humidity = res.firstWhere((element) => element["id"]=="Humidity");
      minimum = res.firstWhere((element) => element["id"]=="Minimum");
      maximum = res.firstWhere((element) => element["id"]=="Maximum");
    });

  }

  List<FlSpot> generateSpots() {
    var data = humidity["data"];
    if (data == null || data is! List<dynamic>) {
      return [];
    }

    return data.whereType<Map<String, dynamic>>().map<FlSpot>((el) {
      // Calculate x as total minutes from "HH:MM"
      List<String> timeParts = el['x'].toString().split(':');
      int x = int.parse(timeParts[0]) * 60 + int.parse(timeParts[1]); // Total minutes
      double y = el['y'].toDouble();
      return FlSpot(x.toDouble(), y);
    }).toList();
  }

  List<FlSpot> generateMaxSpots() {
    var data = maximum["data"];
    if (data == null || data is! List<dynamic>) {
      return [];
    }

    return data.whereType<Map<String, dynamic>>().map<FlSpot>((el) {
      List<String> timeParts = el['x'].toString().split(':');
      int x = int.parse(timeParts[0]) * 60 + int.parse(timeParts[1]); // Total minutes
      double y = el['y'].toDouble();
      return FlSpot(x.toDouble(), y);
    }).toList();
  }

  List<FlSpot> generateMinSpots() {
    var data = minimum["data"];
    if (data == null || data is! List<dynamic>) {
      return [];
    }

    return data.whereType<Map<String, dynamic>>().map<FlSpot>((el) {
      List<String> timeParts = el['x'].toString().split(':');
      int x = int.parse(timeParts[0]) * 60 + int.parse(timeParts[1]); // Total minutes
      double y = el['y'].toDouble();
      return FlSpot(x.toDouble(), y);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    getHumidity();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: theme.colorScheme.onPrimary,
        backgroundColor: theme.primaryColor,
        title: Text(
          "Humidity Chart",
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 24
          ),
        ),
      ),
      backgroundColor: theme.primaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 500,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: 100,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: TextStyle(color: theme.colorScheme.onPrimary),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            // Convert minutes to HH:MM format for display
                            int totalMinutes = value.toInt();
                            int hours = totalMinutes ~/ 60;
                            int minutes = totalMinutes % 60;
                            String formattedTime = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
                            return Text(
                              formattedTime,
                              style: TextStyle(color: theme.colorScheme.onPrimary),
                            );
                          },
                        ),
                      ),
                      // Hide titles on the right side
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      // Hide titles on the top
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: theme.dividerColor),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: generateSpots(),
                        isCurved: true,
                        color: theme.colorScheme.secondary,
                        barWidth: 2,
                        belowBarData: BarAreaData(show: false),
                        dotData: FlDotData(show: true),
                      ),
                      LineChartBarData(
                        spots: generateMinSpots(),
                        isCurved: false,
                        color: Color.fromARGB(255, 81, 91, 193),
                        barWidth: 2,
                        belowBarData: BarAreaData(show: false),
                        dotData: FlDotData(show: true),
                      ),
                      LineChartBarData(
                        spots: generateMaxSpots(),
                        isCurved: false,
                        color: theme.colorScheme.error,
                        barWidth: 2,
                        belowBarData: BarAreaData(show: false),
                        dotData: FlDotData(show: true),
                      ),
                    ],
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: theme.dividerColor,
                          strokeWidth: 1,
                          dashArray: [4],
                        );
                      },
                    ),
                  ),
                ),
              ),
              Legend(title: "Humidity", color: theme.colorScheme.secondary),
            ],
          ),
        ),
      ),
    );
  }
}
