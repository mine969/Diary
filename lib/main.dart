import 'package:flutter/material.dart';
import 'splash_screen.dart';  // Import SplashScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,  // Removes the debug banner
      home: SplashScreen(),  // Start with SplashScreen
    );
  }
}
