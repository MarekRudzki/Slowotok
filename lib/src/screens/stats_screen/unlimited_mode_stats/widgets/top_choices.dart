import 'package:flutter/material.dart';

import 'charts/total_tries_bar_chart.dart';
import 'charts/word_length_bar_chart.dart';

class TopChoices extends StatelessWidget {
  const TopChoices({
    super.key,
    required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.all(8.0),
              child: WordLengthBarChart(isDark: isDark),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TotalTriesBarChart(isDark: isDark),
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
