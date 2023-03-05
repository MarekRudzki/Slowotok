import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'widgets/games_won_pie_chart.dart';
import 'widgets/total_tries_bar_chart.dart';
import 'widgets/word_length_bar_chart.dart';

class OverallStatistics extends StatelessWidget {
  const OverallStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    final statsBox = Hive.box('statsBox');
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Łączna liczba rozgrywek:  ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              statsBox.get('game_counter').toString(),
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        const WinLosePieChart(),
        const Text(
          'Najczęściej wybierana:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              'Długość słowa',
            ),
            const Text(
              'Liczba prób',
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: WordLengthBarChart(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TotalTriesBarChart(),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
