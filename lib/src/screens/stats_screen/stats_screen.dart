import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../services/words_provider.dart';
import '../../services/constants.dart';
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
            appBar: AppBar(
              title: const Text('Statystyki'),
              centerTitle: true,
              actions: [
                StatsReset(wordsProvider: wordsProvider),
              ],
            ),
            body: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Constants.gradientBackgroundLighter,
                    Constants.gradientBackgroundDarker,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Builder(
                builder: (context) {
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
                                const WinLosePieChart(),
                                const TopChoices(),
                                const WinPercentage()
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
