import 'package:flutter/material.dart';

import '/src/screens/stats_screen/wotd_mode_stats/widgets/single_day_stats.dart';
import '/src/screens/stats_screen/wotd_mode_stats/widgets/game_calendar.dart';
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

    return Column(
      children: [
        if (!hasStats)
          const NoStatistics()
        else
          Column(
            children: [
              GameCalendar(
                statsProvider: statsProvider,
              ),
              SingleDayStats(
                statsProvider: statsProvider,
              ),
            ],
          ),
      ],
    );
  }
}
