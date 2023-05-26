import 'package:flutter/material.dart';

import '/src/screens/stats_screen/common_widgets/no_statistics.dart';
import '/src/services/providers/stats_provider.dart';
import 'widgets/charts/games_won_pie_chart.dart';
import 'widgets/win_percentage.dart';
import 'widgets/game_counter.dart';
import 'widgets/top_choices.dart';

class UnlimitedModeStats extends StatelessWidget {
  const UnlimitedModeStats({
    super.key,
    required this.statsProvider,
    required this.isDark,
  });

  final StatsProvider statsProvider;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (statsProvider.getNumberOfGames() == 0)
          const NoStatistics()
        else
          Column(
            children: [
              GameCounter(
                totalGamesNumber: statsProvider.getNumberOfGames(),
              ),
              WinLosePieChart(
                isDark: isDark,
                statsProvider: statsProvider,
              ),
              TopChoices(
                isDark: isDark,
                statsProvider: statsProvider,
              ),
              WinPercentage(
                isDark: isDark,
                statsProvider: statsProvider,
              )
            ],
          ),
      ],
    );
  }
}
