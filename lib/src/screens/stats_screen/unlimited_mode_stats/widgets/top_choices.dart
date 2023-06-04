import 'package:flutter/material.dart';
import 'package:slowotok/src/services/providers/stats_provider.dart';

import 'charts/total_tries_bar_chart.dart';
import 'charts/word_length_bar_chart.dart';

class TopChoices extends StatelessWidget {
  const TopChoices({
    super.key,
    required this.isDark,
    required this.statsProvider,
  });

  final bool isDark;
  final StatsProvider statsProvider;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Divider(
          color: Theme.of(context).dividerColor,
          thickness: 2,
          endIndent: 40,
          indent: 40,
        ),
        const SizedBox(height: 10),
        Text(
          'Najczęściej wybierana:',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Długość słowa',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              'Liczba prób',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: WordLengthBarChart(
                isDark: isDark,
                statsProvider: statsProvider,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: TotalTriesBarChart(
                isDark: isDark,
                statsProvider: statsProvider,
              ),
            ),
          ],
        ),
        Divider(
          color: Theme.of(context).dividerColor,
          thickness: 2,
          endIndent: 40,
          indent: 40,
        ),
      ],
    );
  }
}
