import 'dart:ui';

import 'package:flutter/material.dart';

import '/src/screens/stats_screen/wotd_mode_stats/widgets/game_calendar.dart';
import '/src/screens/stats_screen/common_widgets/stats_type_picker.dart';
import '/src/screens/stats_screen/common_widgets/no_statistics.dart';
import '/src/services/providers/stats_provider.dart';

class WotdModeStats extends StatelessWidget {
  const WotdModeStats({
    super.key,
    required this.statsProvider,
  });

  final StatsProvider statsProvider;

  @override
  Widget build(BuildContext context) {
    final bool hasStats = statsProvider.hasWotdStatistics();

    // Get remaining height of screen
    //(Entire height - notification bar height - AppBar height - StatsTypePicker height)
    final double remainingHeight = MediaQuery.of(context).size.height -
        MediaQueryData.fromWindow(window).padding.top -
        AppBar().preferredSize.height -
        65;

    return Column(
      children: [
        StatsTypePicker(statsProvider: statsProvider),
        if (!hasStats)
          Container(
            width: double.infinity,
            height: remainingHeight,
            child: const NoStatistics(
              hasAnyStats: true,
            ),
          )
        else
          Column(
            //TODO add more charts and stats
            children: [
              GameCalendar(
                statsProvider: statsProvider,
              ),
            ],
          ),
      ],
    );
  }
}
