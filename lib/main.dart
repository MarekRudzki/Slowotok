import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'src/screens/stats_screen/stats_screen.dart';
import 'src/screens/home_screen/home_screen.dart';
import 'src/screens/game_screen/game_screen.dart';
import 'src/services/words_provider.dart';
import 'src/services/custom_theme.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('statsBox');
  await Hive.openBox('wordsoftheday');

  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) {
      runApp(
        ChangeNotifierProvider(
          create: (context) => WordsProvider(),
          child: AdaptiveTheme(
            light: CustomTheme.lightTheme,
            dark: CustomTheme.darkTheme,
            initial: savedThemeMode ?? AdaptiveThemeMode.light,
            builder: (theme, darkTheme) => MaterialApp(
              theme: theme,
              darkTheme: darkTheme,
              title: 'Słowotok',
              routes: {
                '/': (context) => const HomeScreen(),
                'stats_screen': (context) => const StatsScreen(),
                'game_screen': (context) => const GameScreen(),
              },
              debugShowCheckedModeBanner: false,
              initialRoute: '/',
            ),
          ),
        ),
      );
    },
  );
}
 //TODO  add Introduction screen to app
 //https://pub.dev/packages/introduction_screen
