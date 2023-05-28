import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'src/screens/home_screen/home_screen.dart';
import 'src/services/providers/stats_provider.dart';
import 'src/services/providers/words_provider.dart';
import 'src/services/custom_theme.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('unlimitedStatsBox');
  await Hive.openBox('wordsOfTheDay');

  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) {
      //TODO app tests
      initializeDateFormatting().then(
        (_) => runApp(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => WordsProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => StatsProvider(),
              )
            ],
            child: AdaptiveTheme(
              light: CustomTheme.lightTheme,
              dark: CustomTheme.darkTheme,
              initial: savedThemeMode ?? AdaptiveThemeMode.light,
              builder: (theme, darkTheme) => MaterialApp(
                theme: theme,
                darkTheme: darkTheme,
                title: 'Słowotok',
                home: const HomeScreen(),
                debugShowCheckedModeBanner: false,
              ),
            ),
          ),
        ),
      );
    },
  );
}
