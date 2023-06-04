import 'package:flutter/material.dart';

import '/src/services/providers/stats_provider.dart';
import 'charts/win_percentage_bar_chart.dart';

class WinPercentage extends StatelessWidget {
  const WinPercentage({
    super.key,
    required this.isDark,
    required this.statsProvider,
  });

  final bool isDark;
  final StatsProvider statsProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Center(
            child: Text(
              'Wygrane (%) dla poszczególnej długości słów',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 15,
              ),
            ),
          ),
        ),
        WinPercentageBarChart(
          isDark: isDark,
          statsProvider: statsProvider,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  color: const Color.fromRGBO(244, 67, 54, 1),
                  height: 12,
                  width: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Cztery próby',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  color: const Color.fromRGBO(225, 193, 51, 1),
                  height: 12,
                  width: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Pięć prób',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  color: const Color.fromRGBO(76, 175, 80, 1),
                  height: 12,
                  width: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Sześć prób',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 30)
      ],
    );
  }
}
