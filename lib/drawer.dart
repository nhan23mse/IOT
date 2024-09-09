import 'package:flutter/material.dart';
import 'package:iot_app/dashboard.dart';
import 'package:iot_app/datalogtable/humidity_table.dart';
import 'package:iot_app/datalogtable/moisture_table.dart';
import 'package:iot_app/settings.dart';
import 'package:iot_app/datalogtable/temparature_table.dart';

class MainDrawer extends StatefulWidget {
  final String currentScreen;

  const MainDrawer({Key? key, required this.currentScreen}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.primaryColor,
      width: 200,
      child: ListView(
        children: [
          Column(
            children: [
              Text(
                'IoT Portal',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/iot.webp",
                    scale: 2.5,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Quy Do",
                    style: TextStyle(
                      fontSize: 28,
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Administrator",
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.secondary.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 20),
          ListTile(
            textColor: widget.currentScreen == 'Dashboard'
                ? theme.colorScheme.secondary
                : theme.colorScheme.onPrimary,
            iconColor: widget.currentScreen == 'Dashboard'
                ? theme.colorScheme.secondary
                : theme.colorScheme.onPrimary,
            leading: Icon(Icons.home),
            title: Text('Dashboard'),
            onTap: () {
              if (widget.currentScreen != 'Dashboard') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Dashboard(currentScreen: 'Dashboard'),
                  ),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              "Data",
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
          ListTile(
            textColor: widget.currentScreen == 'TemperatureTable'
                ? theme.colorScheme.secondary
                : theme.colorScheme.onPrimary,
            iconColor: widget.currentScreen == 'TemperatureTable'
                ? theme.colorScheme.secondary
                : theme.colorScheme.onPrimary,
            leading: Icon(Icons.thermostat),
            title: Text('Temperatures'),
            onTap: () {
              if (widget.currentScreen != 'TemperatureTable') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TemperatureTable(),
                  ),
                );
              }
            },
          ),
          ListTile(
            textColor: widget.currentScreen == 'HumidityTable'
                ? theme.colorScheme.secondary
                : theme.colorScheme.onPrimary,
            iconColor: widget.currentScreen == 'HumidityTable'
                ? theme.colorScheme.secondary
                : theme.colorScheme.onPrimary,
            leading: Icon(Icons.water_drop_outlined),
            title: Text('Humidity'),
            onTap: () {
              if (widget.currentScreen != 'HumidityTable') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HumidityTable(),
                  ),
                );
              }
            },
          ),
          ListTile(
            textColor: widget.currentScreen == 'MoistureTable'
                ? theme.colorScheme.secondary
                : theme.colorScheme.onPrimary,
            iconColor: widget.currentScreen == 'MoistureTable'
                ? theme.colorScheme.secondary
                : theme.colorScheme.onPrimary,
            leading: Icon(Icons.opacity),
            title: Text('Moisture'),
            onTap: () {
              if (widget.currentScreen != 'MoistureTable') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoistureTable(),
                  ),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              "System",
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
          ListTile(
            textColor: widget.currentScreen == 'Settings'
                ? theme.colorScheme.secondary
                : theme.colorScheme.onPrimary,
            iconColor: widget.currentScreen == 'Settings'
                ? theme.colorScheme.secondary
                : theme.colorScheme.onPrimary,
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              if (widget.currentScreen != 'Settings') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Settings(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
