import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../common_widgets/game_instructions.dart';
import '../../services/hive_statistics.dart';
import '../../services/words_provider.dart';
import '../stats_screen/stats_screen.dart';
import 'widgets/word_total_tries_picker.dart';
import 'widgets/word_length_picker.dart';
import 'widgets/start_game_button.dart';
import '../../common_widgets/options_button.dart';

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
      title: const Text('Na pewno?'),
      content: const Text('Chcesz wyjść z aplikacji?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Nie'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Tak'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final HiveStatistics hiveStatistics = HiveStatistics();

    final isDark =
        context.select((WordsProvider wordsProvider) => wordsProvider.isDark);

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
                  return Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
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
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          borderRadius: BorderRadius.circular(
                            35,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            final savedThemeMode =
                                await AdaptiveTheme.getThemeMode();
                            if (context.mounted) {
                              savedThemeMode == AdaptiveThemeMode.dark
                                  ? AdaptiveTheme.of(context).setLight()
                                  : AdaptiveTheme.of(context).setDark();

                              wordsProvider.toggleTheme();
                            }
                          },
                          icon: AnimatedSwitcher(
                            duration: const Duration(
                              milliseconds: 650,
                            ),
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
                            child: isDark
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
                        padding: const EdgeInsets.all(
                          15,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer
                              .withOpacity(0.6),
                        ),
                        child: Column(
                          children: [
                            OptionsButton(
                              text: 'Tryb nieograniczony',
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0))),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const WordLengthPicker(),
                                            const SizedBox(height: 15),
                                            const WordTotalTriesPicker(),
                                            const SizedBox(height: 20),
                                            const StartGameButton(),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            OptionsButton(
                              text: 'Słówka dnia',
                              onPressed: () {
                                //TODO add this feature
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
                            builder: (context) => const GameInstructions(),
                          );
                        },
                      ),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: 45, vertical: 12),
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(15),
                      //       color: Theme.of(context)
                      //           .colorScheme
                      //           .onPrimaryContainer),
                      //   child: LiteRollingSwitch(
                      //     width: 120,
                      //     value: !isDark,
                      //     colorOff: const Color.fromARGB(255, 38, 117, 42),
                      //     colorOn: const Color.fromARGB(255, 99, 203, 105),
                      //     animationDuration: const Duration(milliseconds: 400),
                      //     iconOn: Icons.sunny,
                      //     iconOff: Icons.nightlight_round,
                      //     onChanged: (bool state) async {
                      //       final savedThemeMode =
                      //           await AdaptiveTheme.getThemeMode();
                      //       if (context.mounted) {
                      //         savedThemeMode == AdaptiveThemeMode.dark
                      //             ? AdaptiveTheme.of(context).setLight()
                      //             : AdaptiveTheme.of(context).setDark();

                      //         wordsProvider.toggleTheme();
                      //       }
                      //     },
                      //     textOn: 'Jasny',
                      //     textOff: 'Ciemny',
                      //     textOnColor: Colors.white,
                      //     onDoubleTap: () {},
                      //     onSwipe: () {},
                      //     onTap: () {},
                      //   ),
                      // ),
                      OptionsButton(
                        text: 'Statystyki',
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const StatsScreen(),
                            ),
                          );
                        },
                      ),
                      OptionsButton(
                        text: 'Wyjdź z gry',
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      )
                    ],
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
