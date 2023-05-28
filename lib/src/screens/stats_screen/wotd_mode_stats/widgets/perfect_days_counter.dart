import 'package:flutter/material.dart';

import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:provider/provider.dart';

import '/src/services/providers/words_provider.dart';
import '/src/services/providers/stats_provider.dart';

class PerfectDaysCounter extends StatelessWidget {
  const PerfectDaysCounter({
    super.key,
    required this.statsProvider,
  });

  final StatsProvider statsProvider;

  @override
  Widget build(BuildContext context) {
    final isDark =
        context.select((WordsProvider wordsProvider) => wordsProvider.isDark());
    final int perfectDays = statsProvider.getNumberOfPerfectDaysInMonth();
    final int daysInMonth = statsProvider.getNumberOfDaysInMonth();

    return RoundedProgressBar(
      height: 40,
      childCenter: Text(
        'Perfekcyjne dni: ${perfectDays}/${daysInMonth}',
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      margin: const EdgeInsets.all(7),
      borderRadius: BorderRadius.circular(6),
      percent: (perfectDays / daysInMonth) * 100,
      milliseconds: 1200,
      style: RoundedProgressBarStyle(
        colorProgress: Colors.green,
        colorProgressDark: Colors.green.shade700,
        colorBorder: isDark
            ? const Color.fromARGB(255, 44, 62, 80)
            : const Color.fromARGB(255, 91, 103, 116),
        backgroundProgress: isDark
            ? const Color.fromARGB(255, 91, 103, 116)
            : const Color.fromARGB(255, 183, 181, 181),
        borderWidth: 3,
      ),
    );
  }
}
