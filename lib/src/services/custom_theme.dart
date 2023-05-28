import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      background: Color.fromARGB(255, 31, 39, 47),
      primary: Colors.white,
      onPrimaryContainer: Color.fromARGB(255, 49, 58, 69),
      onSecondaryContainer: Color.fromARGB(255, 49, 58, 69),
      onTertiaryContainer: Color.fromARGB(49, 234, 232, 232),
      error: Colors.red,
      onError: Colors.yellow,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 45, 141, 50),
    ),
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    dividerColor: const Color.fromARGB(66, 224, 224, 224),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 45, 141, 50),
      ),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      background: Color.fromARGB(255, 244, 244, 244),
      primary: Colors.black,
      onPrimaryContainer: Color.fromARGB(255, 99, 203, 105),
      onSecondaryContainer: Color.fromARGB(255, 232, 229, 229),
      onTertiaryContainer: Color.fromARGB(200, 158, 158, 158),
      error: Colors.red,
      onError: Color.fromARGB(255, 182, 165, 8),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 99, 203, 105),
    ),
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    dividerColor: const Color.fromARGB(148, 135, 131, 131),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 99, 203, 105),
      ),
    ),
  );
}
