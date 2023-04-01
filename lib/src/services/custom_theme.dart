import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      background: Color.fromARGB(255, 37, 36, 36),
      primary: Colors.white,
      secondary: Colors.black,
      onPrimaryContainer: Color.fromARGB(255, 38, 117, 42),
      error: Colors.red,
      onError: Colors.yellow,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 38, 117, 42),
    ),
    dividerColor: const Color.fromARGB(66, 224, 224, 224),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 38, 117, 42),
      ),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      background: Color.fromARGB(255, 246, 246, 246),
      primary: Colors.black,
      secondary: Colors.white,
      onPrimaryContainer: Color.fromARGB(255, 99, 203, 105),
      error: Colors.red,
      onError: Color.fromARGB(255, 182, 165, 8),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 99, 203, 105),
    ),
    dividerColor: const Color.fromARGB(148, 135, 131, 131),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 99, 203, 105),
      ),
    ),
  );
}
