import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:slowotok/src/services/providers/stats_provider.dart';

import 'src/screens/introduction_screen/introduction_screen.dart';
import 'src/screens/stats_screen/stats_screen.dart';
import 'src/screens/home_screen/home_screen.dart';
import 'src/screens/game_screen/game_screen.dart';
import 'src/services/providers/introduction_screen_provider.dart';
import 'src/services/providers/words_provider.dart';
import 'src/services/custom_theme.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('statsBox');
  await Hive.openBox('wordsoftheday');
  await Hive.openBox('introduction_screen');

  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  final bool showIntroductionScreen =
      IntroductionScreenProvider().showIntroductionScreen();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) {
      //TODO add stats for WOTD
      //TODO app tests
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => WordsProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => IntroductionScreenProvider(),
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
