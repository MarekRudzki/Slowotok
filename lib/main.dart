import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'src/screens/home_screen/home_screen.dart';
import 'src/services/words_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WordsProvider(),
      child: MaterialApp(
        title: 'Słowotok',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.purple.shade700,
          backgroundColor: Colors.purple.shade900,
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(
                Colors.white,
              ),
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    ),
  );
}
