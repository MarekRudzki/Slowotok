import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:slowotok/src/screens/introduction_screen/introduction_screen.dart';
import 'package:slowotok/src/services/hive_introduction_screen.dart';

import 'src/screens/home_screen/home_screen.dart';
import 'src/screens/stats_screen/stats_screen.dart';
import 'src/screens/game_screen/game_screen.dart';
import 'src/services/words_provider.dart';
import 'src/services/custom_theme.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('statsBox');
  await Hive.openBox('wordsoftheday');
  await Hive.openBox('introduction_screen');

  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  final bool showIntroductionScreen =
      HiveIntroductionScreen().getIntroductionScreenStatus();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) {
      //TODO add Introduction screen to app
      //https://pub.dev/packages/introduction_screen
      //TODO adjust UI
      //TODO app tests
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
                '/': (context) => showIntroductionScreen
                    ? const IntroductionScreen()
                    : const HomeScreen(),
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
