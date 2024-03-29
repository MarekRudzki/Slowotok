import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';

import '/src/common_widgets/game_instructions/game_instructions.dart';
import '/src/common_widgets/options_button.dart';
import '/src/screens/game_screen/widgets/words_of_the_day_summary_dialog.dart';
import '/src/screens/game_screen/game_screen.dart';
import '/src/screens/home_screen/widgets/unlimited_game_mode.dart';
import '/src/screens/home_screen/widgets/theme_switcher.dart';
import '/src/screens/stats_screen/stats_screen.dart';
import '/src/services/hive/hive_words_of_the_day.dart';
import '/src/services/hive/hive_unlimited.dart';
import '/src/services/providers/stats_provider.dart';
import '/src/services/providers/words_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StatsProvider statsProvider = StatsProvider(
      hiveUnlimited: HiveUnlimited(),
      hiveWordsOfTheDay: HiveWordsOfTheDay(),
    );

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: FutureBuilder(
            future: statsProvider.checkForStatistics(),
            builder: (context, snapshot) {
              return Consumer<WordsProvider>(
                builder: (context, wordsProvider, _) {
                  return FutureBuilder(
                    future: AdaptiveTheme.getThemeMode(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        wordsProvider.setTheme(snapshot.data!);

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Material(
                                  color: Colors.transparent,
                                  elevation: 25,
                                  child: Center(
                                    child: Image.asset(
                                      gaplessPlayback: true,
                                      !wordsProvider.isDark()
                                          ? 'assets/icon.png'
                                          : 'assets/icon2.png',
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Column(
                                children: [
                                  const UnlimitedGameMode(),
                                  OptionsButton(
                                    text: 'Słówka dnia',
                                    onPressed: () async {
                                      wordsProvider.setSelectedDay(
                                          date: DateTime.now());
                                      wordsProvider.setMissedDayStatus(
                                          playingMissedDay: false);
                                      final bool modeAvailable =
                                          await wordsProvider
                                              .gameModeAvailable();
                                      if (!modeAvailable) {
                                        wordsProvider.setWotdDialogPage(
                                            indexPage: 0);
                                        if (context.mounted)
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return WordsOfTheDaySummaryDialog(
                                                provider: wordsProvider,
                                              );
                                            },
                                          );
                                        return;
                                      }
                                      wordsProvider.playWotdMode(
                                        date: DateTime.now(),
                                      );

                                      if (context.mounted)
                                        await wordsProvider
                                            .setRandomWord(
                                          context: context,
                                        )
                                            .then(
                                          (value) {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const GameScreen(),
                                              ),
                                            );
                                          },
                                        );
                                    },
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Flexible(
                                    flex: 4,
                                    child: OptionsButton(
                                      text: 'Jak grać?',
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              GameInstructions(
                                            wordsProvider: wordsProvider,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: ThemeSwitcher(
                                      wordsProvider: wordsProvider,
                                    ),
                                  ),
                                ],
                              ),
                              OptionsButton(
                                text: 'Statystyki',
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const StatsScreen(
                                        showUnlimitedFirst: true,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 25),
                              OptionsButton(
                                text: 'Wyjdź z gry',
                                onPressed: () {
                                  SystemNavigator.pop();
                                },
                              ),
                              const SizedBox(height: 15)
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

Future<bool> _onWillPop(BuildContext context) async {
  final bool? exitResult = await showDialog(
    context: context,
    builder: (context) => _buildExitDialog(context),
  );
  return exitResult ?? false;
}

AlertDialog _buildExitDialog(BuildContext context) {
  return AlertDialog(
    title: Text(
      'Na pewno?',
      style: TextStyle(
        fontSize: 18,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
    content: Text(
      'Chcesz wyjść z aplikacji?',
      style: TextStyle(
        fontSize: 15,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
    backgroundColor: Theme.of(context).colorScheme.background,
    contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: Text(
          'Nie',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(
          'Tak',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    ],
  );
}
