import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; // Import your new screen
import 'screens/welcome_screen.dart';
void main() {
  runApp(BusTrackingApp());
}

class BusTrackingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Bus Tracker",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Roboto",
      ),
      home: SplashScreen(),
      routes: {
      '/home': (context) => WelcomeScreen(), // your main app
    }, // Set as home for driver flow
    );
  }
}
