import 'package:flutter/material.dart';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';

import '/src/services/providers/stats_provider.dart';
import 'unlimited_mode_stats/unlimited_mode_stats.dart';
import 'wotd_mode_stats/wotd_mode_stats.dart';
import 'common_widgets/stats_reset.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({
    super.key,
    required this.showUnlimitedFirst,
  });

  final bool showUnlimitedFirst;

  @override
  Widget build(BuildContext context) {
    if (showUnlimitedFirst) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          final StatsProvider statsProvider =
              Provider.of<StatsProvider>(context, listen: false);
          if (statsProvider.getDisplayedStatsType() == 'wotd') {
            statsProvider.setDisplayedStatsType(statsType: 'unlimited');
          }
        },
      );
    }

    return SafeArea(
      child: Consumer<StatsProvider>(
        builder: (context, statsProvider, _) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              title: const Text(
                'Statystyki',
                style: TextStyle(
                  color: Colors.white,
                ),
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
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor:
                  Theme.of(context).colorScheme.onSecondaryContainer,
              selectedItemColor: Colors.green,
              selectedIconTheme: const IconThemeData(
                size: 25,
              ),
              unselectedItemColor: Colors.grey,
              currentIndex:
                  statsProvider.getDisplayedStatsType() == 'unlimited' ? 0 : 1,
              onTap: (value) {
                statsProvider.setDisplayedStatsType(
                    statsType: value == 0 ? 'unlimited' : 'wotd');
              },
              elevation: 10,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.all_inclusive_rounded,
                  ),
                  label: 'Tryb nieograniczony',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.today,
                  ),
                  label: 'Słówka dnia',
                ),
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

                  return SingleChildScrollView(
                    child: context.select((StatsProvider statsProvider) =>
                            statsProvider.getDisplayedStatsType() ==
                            'unlimited')
                        ? UnlimitedModeStats(
                            statsProvider: statsProvider,
                            isDark: isDark,
                          )
                        : WotdModeStats(statsProvider: statsProvider),
                  );
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
