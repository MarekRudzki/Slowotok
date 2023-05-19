import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

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
    required this.statsBox,
  });

  final StatsProvider statsProvider;
  final bool isDark;
  final Box<dynamic> statsBox;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (statsProvider.getNumberOfGames() == 0)
          const NoStatistics()
        else
          Column(
            children: [
              GameCounter(statsBox: statsBox),
              WinLosePieChart(isDark: isDark),
              TopChoices(isDark: isDark),
              WinPercentage(isDark: isDark)
            ],
          ),
      ],
    );
  }
}
