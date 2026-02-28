import 'package:flutter/material.dart';
import 'features/navigation/main_navigation_screen.dart';

void main() {
  runApp(const FinPulseApp());
}

class FinPulseApp extends StatelessWidget {
  const FinPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF040B16),
      ),

      home: const MainNavigationScreen(),
    );
  }
}