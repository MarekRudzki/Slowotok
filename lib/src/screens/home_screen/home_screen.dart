import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';
import 'package:slowotok/src/screens/game_screen/widgets/word_of_the_day_summary_dialog.dart';

import '/src/common_widgets/game_instructions.dart';
import '/src/common_widgets/options_button.dart';
import '/src/services/hive_statistics.dart';
import '/src/services/words_provider.dart';
import 'widgets/unlimited_game_mode.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    final HiveStatistics hiveStatistics = HiveStatistics();

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: FutureBuilder(
            future: hiveStatistics.checkForStatistics(),
            builder: (context, snapshot) {
              return Consumer<WordsProvider>(
                builder: (context, wordsProvider, _) {
                  return FutureBuilder(
                    future: AdaptiveTheme.getThemeMode(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        wordsProvider.setTheme(snapshot.data!);

                        return Column(
                          children: [
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Material(
                                color: Colors.transparent,
                                elevation: 25,
                                child: Center(
                                  child: Image.asset(
                                    gaplessPlayback: true,
                                    !wordsProvider.isDark
                                        ? 'assets/icon.png'
                                        : 'assets/icon2.png',
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: IconButton(
                                //TODO find fitting place for theme change
                                onPressed: () async {
                                  if (wordsProvider.isDark) {
                                    AdaptiveTheme.of(context).setLight();
                                    wordsProvider
                                        .setTheme(AdaptiveThemeMode.light);
                                  } else {
                                    AdaptiveTheme.of(context).setDark();
                                    wordsProvider
                                        .setTheme(AdaptiveThemeMode.dark);
                                  }
                                },
                                icon: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 650),
                                  transitionBuilder: (child, animation) =>
                                      RotationTransition(
                                    turns: child.key ==
                                            const ValueKey(
                                              'icon1',
                                            )
                                        ? Tween<double>(begin: 1, end: 0.5)
                                            .animate(animation)
                                        : Tween<double>(begin: 0.5, end: 1)
                                            .animate(animation),
                                    child: FadeTransition(
                                        opacity: animation, child: child),
                                  ),
                                  child: wordsProvider.isDark
                                      ? Icon(
                                          size: 30,
                                          color: Colors.blue.shade700,
                                          Icons.mode_night,
                                          key: const ValueKey(
                                            'icon1',
                                          ),
                                        )
                                      : const Icon(
                                          size: 30,
                                          color: Colors.amber,
                                          Icons.sunny,
                                          key: ValueKey(
                                            'icon2',
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35),
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                    .withOpacity(0.6),
                              ),
                              child: Column(
                                children: [
                                  const UnlimitedGameMode(),
                                  const SizedBox(height: 20),
                                  OptionsButton(
                                    text: 'Słówka dnia',
                                    onPressed: () async {
                                      final bool modeAvailable =
                                          await wordsProvider
                                              .gameModeAvailable();
                                      if (!modeAvailable) {
                                        if (context.mounted)
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return WordOfTheDaySummaryDialog(
                                                provider: wordsProvider,
                                              );
                                            },
                                          );
                                        return;
                                      }
                                      wordsProvider.setTotalTries(6);
                                      wordsProvider.setWordLength(5);

                                      if (context.mounted)
                                        await wordsProvider
                                            .setRandomWord(
                                          context: context,
                                        )
                                            .then(
                                          (value) {
                                            wordsProvider.changeGameMode(
                                                newGameMode: 'wordsoftheday');
                                            Navigator.pushNamed(
                                                context, 'game_screen');
                                          },
                                        );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            OptionsButton(
                              text: 'Jak grać?',
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const GameInstructions(),
                                );
                              },
                            ),
                            OptionsButton(
                              text: 'Statystyki',
                              onPressed: () {
                                Navigator.pushNamed(context, 'stats_screen');
                              },
                            ),
                            OptionsButton(
                              text: 'Wyjdź z gry',
                              onPressed: () {
                                SystemNavigator.pop();
                              },
                            ),
                            const SizedBox(height: 15)
                          ],
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
