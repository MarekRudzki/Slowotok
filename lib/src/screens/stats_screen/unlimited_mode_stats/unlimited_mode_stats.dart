import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '/src/screens/stats_screen/common_widgets/stats_type_picker.dart';
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
    // Get remaining height of screen
    //(Entire height - notification bar height - AppBar height - StatsTypePicker height)
    final double remainingHeight = MediaQuery.of(context).size.height -
        MediaQueryData.fromWindow(window).padding.top -
        AppBar().preferredSize.height -
        65;

    return Column(
      children: [
        StatsTypePicker(statsProvider: statsProvider),
        if (statsProvider.getNumberOfGames() == 0)
          Container(
            height: remainingHeight,
            child: const NoStatistics(
              hasAnyStats: true,
            ),
          )
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
