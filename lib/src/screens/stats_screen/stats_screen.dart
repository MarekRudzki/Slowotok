import 'package:flutter/material.dart';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '/src/services/providers/words_provider.dart';
import 'widgets/charts/games_won_pie_chart.dart';
import 'widgets/win_percentage.dart';
import 'widgets/no_statistics.dart';
import 'widgets/game_counter.dart';
import 'widgets/top_choices.dart';
import 'widgets/stats_reset.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final statsBox = Hive.box('statsBox');

    return SafeArea(
      child: Consumer<WordsProvider>(
        builder: (context, wordsProvider, _) {
          final int gamesPlayed = statsBox.get('game_counter') as int;

          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              title: const Text(
                'Statystyki',
              ),
              centerTitle: true,
              actions: [
                StatsReset(wordsProvider: wordsProvider),
              ],
            ),
            body: FutureBuilder(
              future: AdaptiveTheme.getThemeMode(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final bool isDark;
                  snapshot.data == AdaptiveThemeMode.dark
                      ? isDark = true
                      : isDark = false;

                  if (gamesPlayed == 0) {
                    return const NoStatistics();
                  } else {
                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                GameCounter(statsBox: statsBox),
                                WinLosePieChart(isDark: isDark),
                                TopChoices(isDark: isDark),
                                WinPercentage(isDark: isDark)
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
