import 'package:flutter/material.dart';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';

import '/src/services/providers/stats_provider.dart';
import 'unlimited_mode_stats/unlimited_mode_stats.dart';
import 'wotd_mode_stats/wotd_mode_stats.dart';
import 'common_widgets/no_statistics.dart';
import 'common_widgets/stats_reset.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<StatsProvider>(
        builder: (context, statsProvider, _) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              title: const Text(
                'Statystyki',
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  Navigator.of(context).pop();
                },
              ),
              actions: [
                StatsReset(statsProvider: statsProvider),
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

                  if (statsProvider.getNumberOfGames() == 0) {
                    return const NoStatistics(
                      hasAnyStats: false,
                    );
                  } else {
                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: statsProvider.getDisplayedStatsType() ==
                                    'unlimited'
                                ? UnlimitedModeStats(
                                    statsProvider: statsProvider,
                                    isDark: isDark,
                                    statsBox: statsProvider.getStatsBox(),
                                  )
                                : WotdModeStats(
                                    statsProvider: statsProvider,
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
