import 'package:flutter/material.dart';

class AppTheme {
  static const primaryDark = Color(0xFF0F172A);
  static const cardDark = Color(0xFF1E293B);
  static const accentGreen = Color(0xFF22C55E);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F7FA),
    cardColor: Colors.white,
    primaryColor: const Color(0xFF334155),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xFF1E293B)),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: primaryDark,
    cardColor: cardDark,
    primaryColor: Colors.white,
  );
}