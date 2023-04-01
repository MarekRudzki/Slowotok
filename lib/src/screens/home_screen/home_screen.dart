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
import 'widgets/menu_button.dart';

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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
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
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          padding: const EdgeInsets.all(
                            15,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.green,
                              width: 5,
                            ),
                          ),
                          child: Column(
                            children: [
                              const WordLengthPicker(),
                              const SizedBox(height: 15),
                              const WordTotalTriesPicker(),
                              const SizedBox(height: 20),
                              const StartGameButton(),
                            ],
                          ),
                        ),
                      ), //TODO add word of the day
                      // Container(
                      //   //TODO edit this
                      //   margin: const EdgeInsets.all(8),
                      //   decoration: BoxDecoration(
                      //     color: Colors.red,
                      //     borderRadius: BorderRadius.circular(
                      //       25,
                      //     ),
                      //   ),
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(3.0),
                      //     child: LiteRollingSwitch(
                      //       width: 120,
                      //       value: !isDark,
                      //       colorOff: const Color.fromARGB(255, 38, 117, 42),
                      //       colorOn: const Color.fromARGB(255, 99, 203, 105),
                      //       animationDuration:
                      //           const Duration(milliseconds: 400),
                      //       iconOn: Icons.sunny,
                      //       iconOff: Icons.nightlight_round,
                      //       onChanged: (bool state) async {
                      //         final savedThemeMode =
                      //             await AdaptiveTheme.getThemeMode();
                      //         if (context.mounted) {
                      //           savedThemeMode == AdaptiveThemeMode.dark
                      //               ? AdaptiveTheme.of(context).setLight()
                      //               : AdaptiveTheme.of(context).setDark();

                      //           wordsProvider.toggleTheme();
                      //         }
                      //       },
                      //       textOn: 'Jasny',
                      //       textOff: 'Ciemny',
                      //       textOnColor: Colors.white,
                      //       onDoubleTap: () {},
                      //       onSwipe: () {},
                      //       onTap: () {},
                      //     ),
                      //   ),
                      // ),
                      MenuButton(
                        text: 'Jak grać?',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const GameInstructions(),
                          );
                        },
                      ),
                      MenuButton(
                        text: 'Statystyki',
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const StatsScreen(),
                            ),
                          );
                        },
                      ),
                      MenuButton(
                        text: 'Wyjdź z gry',
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                      ),
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
