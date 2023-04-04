import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/game_instructions.dart';
import '../../common_widgets/options_button.dart';
import '../../services/hive_statistics.dart';
import '../../services/words_provider.dart';
import '../stats_screen/stats_screen.dart';
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
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                  borderRadius: BorderRadius.circular(
                                    35,
                                  ),
                                ),
                                child: IconButton(
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
                                    const UnlimitedGameMode(),
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
                                    builder: (context) =>
                                        const GameInstructions(),
                                  );
                                },
                              ),
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
                        }
                        return const SizedBox.shrink();
                      });
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
