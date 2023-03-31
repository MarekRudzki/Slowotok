import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'src/screens/home_screen/home_screen.dart';
import 'src/services/words_provider.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('statsBox');
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      ChangeNotifierProvider(
        create: (context) => WordsProvider(),
        child: MaterialApp(
          title: 'Słowotok',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(
            dialogTheme: DialogTheme(
              backgroundColor: Colors.purple.shade900,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.purple.shade900,
            ),
            primaryColor: Colors.purple.shade700,
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
  });
}
