import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:slowotok/src/screens/stats_screen/wotd_mode_stats/widgets/perfect_days_counter.dart';
import 'package:slowotok/src/services/hive/hive_words_of_the_day.dart';

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
              PerfectDaysCounter(
                statsProvider: statsProvider,
              ),
              GameCalendar(
                statsProvider: statsProvider,
              ),
              SingleDayStats(
                statsProvider: statsProvider,
              ),
              ElevatedButton(
                onPressed: () async {
                  final box = Hive.box('wordsOfTheDay');

                  final Map<String, List<bool>> existingStats =
                      HiveWordsOfTheDay().getWotdStats();
                  existingStats.addAll(
                    {
                      '2023-05-14': [
                        true,
                        true,
                      ],
                    },
                  );
                  await box.put('days_stats', existingStats);
                },
                child: const Text(
                  'add',
                ),
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     for (int i = 1; i < 13; i++) {
              //       print(
              //           'miesiac${i}: ${statsProvider.getNumberOfDaysInMonth()}');
              //     }
              //   },
              //   child: const Text(
              //     'test',
              //   ),
              // ),
            ],
          ),
      ],
    );
  }
}
