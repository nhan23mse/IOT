import 'package:flutter/material.dart';
import 'package:iot_app/ThemeProvider.dart';
import 'package:iot_app/dashboard.dart';
import 'package:provider/provider.dart'; // Import provider package
// import 'package:flutter/services.dart';
void main() {
  //   WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]).then((_) {
  //   runApp(MyApp());
  // });
  runApp(
    
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: IotApp(),
    ),
  );
}

class IotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Access ThemeProvider

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IoT Monitoring System',
      theme: lightTheme, // Light theme
      darkTheme: darkTheme, // Dark theme
      themeMode: themeProvider.themeMode, // Use theme mode from provider
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Dashboard();
  }
}

// Define the light theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  secondaryHeaderColor: Colors.blueAccent,
  cardColor: Color.fromARGB(255, 242, 240, 240),
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: Colors.black),
    headlineMedium: TextStyle(fontSize: 28),
    bodyLarge: TextStyle(fontSize: 16),
  ),
  colorScheme: ColorScheme.light(
    onPrimary: Colors.black,
    primary: Colors.white,
    secondary: Color.fromARGB(255, 37, 213, 179),
    surface: Colors.white,
    error: Colors.redAccent,
    onSecondary: Colors.blueAccent
  )
);

// Define the dark theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color.fromARGB(255, 21, 28, 47),
  scaffoldBackgroundColor: Color.fromARGB(255, 21, 28, 47),
  secondaryHeaderColor: Color.fromARGB(255, 32, 50, 77),
  cardColor: Color.fromARGB(255, 32, 50, 77),
  colorScheme: ColorScheme.dark(
    onPrimary: Colors.white,
    primary: Colors.black,
    secondary: Color.fromARGB(255, 37, 213, 179),
    surface: Color.fromARGB(255, 21, 28, 47),
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
  ),
);
