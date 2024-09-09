import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iot_app/api/sensors_repo.dart';
import 'package:iot_app/appbar.dart';
import 'package:iot_app/dashboard.dart';
import 'package:iot_app/drawer.dart';
import 'package:http/http.dart' as http;

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // Variables for Temperature
  late double? _maxTemp = null;
  late double? _minTemp = null;

  // Variables for Humidity
  late double? _maxHumidity = null;
  late double? _minHumidity = null;

  // Variables for Moisture
  late double? _maxMoisture = null;
  late double? _minMoisture = null;

  late String sensorName = "";

  Map<String, dynamic> settings =
    {
      "id": 9,
      "max_humidity": 90.0,
      "max_moisture": null,
      "max_temperature": 27.0,
      "min_humidity": 10.0,
      "min_moisture": null,
      "min_temperature": 10.0,
      "sensor_id": 1
    };

  // Define sensors as a list of maps
  List<Map<String, dynamic>> sensors = [
    {
      "id": 1,
      "location": "Weed Garden",
      "location_id": 1,
      "name": "DHT11",
      "type": "temperature",
      "type_id": 1
    },
    {
      "id": 2,
      "location": "Weed Garden",
      "location_id": 1,
      "name": "SMSV1",
      "type": "moisture",
      "type_id": 2
    }
  ];

  late String? _selectedOption = null;

  @override
  void initState() {
    _loadData(); // Load sensors and settings data
    _updateSliderValues(); // Update slider values after loading data
    super.initState();
  }

// Load sensors and settings data
  Future<void> _loadData() async {
    // Fetch sensors and settings data from the repositories
    dynamic dataSensors = await SensorsRepo.getSensors();
    dynamic dataSettings = await SensorsRepo.getSettingsById(1);
    setState(() {
      sensors = List<Map<String, dynamic>>.from(dataSensors);
      settings = Map<String, dynamic>.from(dataSettings);
    });
    _selectedOption = sensors[0]["name"];

    // After loading data, update the slider values to reflect the settings
    _updateMinMaxValues();
  }

  Future<void> _saveSettings(BuildContext context) async {
    if (_selectedOption != null) {
      // Find the sensor based on the selected option (sensor name)
      final selectedSensor = sensors.firstWhere(
            (sensor) => sensor['name'] == _selectedOption,
        orElse: () => {},
      );

      if (selectedSensor.isNotEmpty) {
        final sensorId = selectedSensor['id'];

        // Create a settings map to save
        final settingsToSave = {
          'sensor_id': sensorId,
          'max_temperature': _maxTemp==null?null:_maxTemp!*100,
          'min_temperature': _minTemp==null?null:_minTemp!*100,
          'max_humidity': _maxHumidity==null?null:_maxHumidity!*100,
          'min_humidity': _minHumidity==null?null:_minHumidity!*100,
          'max_moisture': _maxMoisture==null?null:_maxMoisture!*100,
          'min_moisture': _minMoisture==null?null:_minMoisture!*100,
          'id': sensorId,
        };

        try {
          // Save the settings using the repository
          final res = await SensorsRepo.updateSettingsById(sensorId, settingsToSave);
          print(res);
          _showSaveSuccessDialog(context);
        } catch (error) {
          // Handle save error (e.g., show an error dialog or log the error)
          print('Error saving settings: $error');
        }
      }
    }
  }

// Update slider values based on selected sensor settings
  void _updateSliderValues() async {
    if (_selectedOption != null) {
      final selectedSensor = sensors.firstWhere(
            (sensor) => sensor['name'] == _selectedOption,
        orElse: () => {},
      );

      if (selectedSensor.isNotEmpty) {
        final sensorId = selectedSensor['id'];
        dynamic dataSettings = await SensorsRepo.getSettingsById(sensorId);
        setState(() {
          settings = Map<String, dynamic>.from(dataSettings);
        });
        _updateMinMaxValues();
      }
    }
  }

  void _updateMinMaxValues() {

          setState(() {
            _maxTemp = (settings['max_temperature'] != null)
                ? settings['max_temperature'] / 100
                : null;
            _minTemp = (settings['min_temperature'] != null)
                ? settings['min_temperature'] / 100
                : null;
            _maxHumidity = (settings['max_humidity'] != null)
                ? settings['max_humidity'] / 100
                : null;
            _minHumidity = (settings['min_humidity'] != null)
                ? settings['min_humidity'] / 100
                : null;
            _maxMoisture = (settings['max_moisture'] != null)
                ? settings['max_moisture'] / 100
                : null;
            _minMoisture = (settings['min_moisture'] != null)
                ? settings['min_moisture'] / 100
                : null;
          });
    }

  void _showSaveSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Settings saved successfully.'),
        );
      },
    );

    // Wait for 500 milliseconds before navigating to the dashboard
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.of(context).pop(); // Close the dialog
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      drawer: MainDrawer(
        currentScreen: 'Settings',
      ),
      appBar: MainAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: ListView(children: [
          Text(
            "Settings",
            style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 36),
          ),
          Row(
            children: [
              Text(
                "Settings for sensor ",
                style:
                    TextStyle(color: theme.colorScheme.secondary, fontSize: 14),
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
                    print(newValue);
                    _selectedOption = newValue!;
                    _updateSliderValues();
                  });
                },
                width: 250,
                inputDecorationTheme: InputDecorationTheme(
                  constraints: BoxConstraints(
                    maxHeight: 46
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
                    value: sensor['name'], // Use sensor name
                    label: sensor['name'], // Display sensor name
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
          if (_selectedOption != null) ...[
            const SizedBox(height: 16),
            if (_maxTemp != null) ...[
              Text("Temperatures",
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(color: theme.colorScheme.onPrimary)),
              Text("Minimum",
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.colorScheme.onPrimary)),
              Slider(
                activeColor: theme.colorScheme.secondary,
                inactiveColor: theme.colorScheme.secondary.withOpacity(0.2),
                value: _minTemp!,
                onChanged: (newValue) {
                  setState(() {
                    _minTemp = newValue;
                  });
                },
                min: 0.0,
                max: 1.0,
                divisions: 100,
                label: (_minTemp! * 100).toStringAsFixed(0) + '°C',
              ),
              Text("Maximum",
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.colorScheme.onPrimary)),
              Slider(
                activeColor: theme.colorScheme.secondary,
                inactiveColor: theme.colorScheme.secondary.withOpacity(0.2),
                value: _maxTemp!,
                onChanged: (newValue) {
                  setState(() {
                    _maxTemp = newValue;
                  });
                },
                min: 0.0,
                max: 1.0,
                divisions: 100,
                label: (_maxTemp! * 100).toStringAsFixed(0) + '°C',
              ),
              const SizedBox(height: 24),
            ],
            if (_maxHumidity != null) ...[
              Text("Humidity",
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(color: theme.colorScheme.onPrimary)),
              Text("Minimum",
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.colorScheme.onPrimary)),
              Slider(
                activeColor: theme.colorScheme.secondary,
                inactiveColor: theme.colorScheme.secondary.withOpacity(0.2),
                value: _minHumidity!,
                onChanged: (newValue) {
                  setState(() {
                    _minHumidity = newValue;
                  });
                },
                min: 0.0,
                max: 1.0,
                divisions: 100,
                label: (_minHumidity! * 100).toStringAsFixed(0) + '%',
              ),
              Text("Maximum",
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.colorScheme.onPrimary)),
              Slider(
                activeColor: theme.colorScheme.secondary,
                inactiveColor: theme.colorScheme.secondary.withOpacity(0.2),
                value: _maxHumidity!,
                onChanged: (newValue) {
                  setState(() {
                    _maxHumidity = newValue;
                  });
                },
                min: 0.0,
                max: 1.0,
                divisions: 100,
                label: (_maxHumidity! * 100).toStringAsFixed(0) + '%',
              ),
              const SizedBox(height: 24),
            ],
            if (_maxMoisture != null) ...[
              Text("Moisture",
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(color: theme.colorScheme.onPrimary)),
              Text("Minimum",
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.colorScheme.onPrimary)),
              Slider(
                activeColor: theme.colorScheme.secondary,
                inactiveColor: theme.colorScheme.secondary.withOpacity(0.2),
                value: _minMoisture!,
                onChanged: (newValue) {
                  setState(() {
                    _minMoisture = newValue;
                  });
                },
                min: 0.0,
                max: 1.0,
                divisions: 100,
                label: (_minMoisture! * 100).toStringAsFixed(0) + '%',
              ),
              Text("Maximum",
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.colorScheme.onPrimary)),
              Slider(
                activeColor: theme.colorScheme.secondary,
                inactiveColor: theme.colorScheme.secondary.withOpacity(0.2),
                value: _maxMoisture!,
                onChanged: (newValue) {
                  setState(() {
                    _maxMoisture = newValue;
                  });
                },
                min: 0.0,
                max: 1.0,
                divisions: 100,
                label: (_maxMoisture! * 100).toStringAsFixed(0) + '%',
              ),
              const SizedBox(height: 24),
            ],
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                onPressed: () {
                  _saveSettings(context);
                },
                child: Text("Save",
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.onSecondary)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ]),
      ),
    );
  }
}
