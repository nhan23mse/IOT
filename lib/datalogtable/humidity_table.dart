import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iot_app/api/humidity_repo.dart';
import 'package:iot_app/appbar.dart';
import 'package:iot_app/drawer.dart';

class HumidityTable extends StatefulWidget {
  const HumidityTable({super.key});

  @override
  State<HumidityTable> createState() => _HumidityTableState();
}
class _HumidityTableState extends State<HumidityTable> {
  late List<Map<String, dynamic>> data = [];

  List<String> sensors = ['WD-Temperature-01',];

  late String? _selectedOption = 'WD-Temperature-01';


  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    dynamic humidityData = await HumidityRepo.getHumidityTable(1);
    setState(() {
      data = List<Map<String, dynamic>>.from(humidityData);
      _selectedOption = data[0]["sensor_name"];
    });
  }

  String formatDate(String originalDate){
    DateTime dateTime = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", 'en_US').parse(originalDate, true);

    // Convert to desired time zone (UTC+7)
    DateTime dateTimeInUTC7 = dateTime.toUtc().add(Duration(hours: 7));

    // Format the date to your desired format
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTimeInUTC7);
    return formattedDate;
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      drawer: MainDrawer(currentScreen: 'HumidityTable',),
      appBar: MainAppBar(),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 4, bottom: 4,right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Humidity",
                    style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 36
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Sensor ",
                        style: TextStyle(
                            color: theme.colorScheme.secondary,
                            fontSize: 14
                        ),
                      ),
                      DropdownMenu<String>(
                        trailingIcon: Icon(
                          Icons.add,
                          size: 0,
                        ),
                        selectedTrailingIcon: Icon(
                          Icons.add,
                          size: 0,
                        ),
                        onSelected: (String? newValue) {
                          setState(() {
                            _selectedOption = newValue!;
                          });
                        },
                        inputDecorationTheme: InputDecorationTheme(
                          constraints: BoxConstraints(
                            maxHeight: 46,
                          ),
                          contentPadding: EdgeInsets.all(0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        initialSelection: _selectedOption,
                        dropdownMenuEntries:
                        sensors.map<DropdownMenuEntry<String>>((sensor) {
                          return DropdownMenuEntry<String>(
                            value: sensor, // Use sensor name
                            label: sensor, // Display sensor name
                          );
                        }).toList(),
                        menuStyle: MenuStyle(
                          backgroundColor: WidgetStateProperty.all(
                              theme.cardColor), // secondary color
                          shadowColor: WidgetStateProperty.all(
                              theme.cardColor.withOpacity(0.2)), // tertiary color
                        ),
                        textStyle: TextStyle(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if(_selectedOption!=null && data.isNotEmpty)...[SizedBox(height: 16,),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: theme.cardColor,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[index]["sensor_name"],
                                  style: TextStyle(
                                    color: theme.colorScheme.onPrimary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  data[index]["location"],
                                  style: TextStyle(
                                    color: theme.colorScheme.onPrimary.withOpacity(0.6),
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  formatDate(data[index]["date_time"]),
                                  style: TextStyle(
                                    color: theme.colorScheme.secondary,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Transform.translate(
                              offset: Offset(-10, 0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.water_drop_outlined,
                                    color: theme.colorScheme.secondary,
                                    size: 40,
                                  ),
                                  Text(
                                    data[index]["humidity"].toString() + "%",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: theme.colorScheme.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),]
          ],
        ),
      ),
    );
  }
}
