import 'dart:ui';

import 'package:flutter/material.dart';

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
    List<bool> dayStats = statsProvider.getSingleDayStats();
    final bool hasStats = statsProvider.hasWotdStatistics();

    // Get remaining height of screen
    // (Entire height - notification bar height - AppBar height)
    final double remainingHeight = MediaQuery.of(context).size.height -
        MediaQueryData.fromWindow(window).padding.top -
        AppBar().preferredSize.height;

    return Column(
      children: [
        if (!hasStats)
          Container(
            width: double.infinity,
            height: remainingHeight,
            child: const NoStatistics(),
          )
        else
          Column(
            children: [
              GameCalendar(
                statsProvider: statsProvider,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: const Color.fromARGB(67, 163, 162, 162),
                  child: Column(
                    children: [
                      Text(
                        statsProvider.getSelectedDateFormatted(
                            statsProvider.getSelectedDay()),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.green),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green),
                              ),
                            ),
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        // ElevatedButton(
        //   //TODO testing
        //   onPressed: () async {
        //     // await statsProvider.addStatsForDay(
        //     //   isWin: [true, false, true],
        //     //   day: '2023-05-05',
        //     // );
        //     statsProvider.getSeletedDay(date: DateTime(2023, 5, 10));
        //   },
        //   child: const Text('abc'),
        // ),
      ],
    );
  }
}
