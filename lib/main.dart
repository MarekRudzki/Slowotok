import 'package:flutter/material.dart';

import 'package:slowotok/screens/home_screen/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Słowotok',
      theme: ThemeData.dark().copyWith(
          primaryColor: Colors.purple.shade700,
          backgroundColor: Colors.purple.shade900,
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ))),
      home: const HomeScreen(),
    ),
  );
}
