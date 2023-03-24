import 'package:flutter/material.dart';

import 'charts/total_tries_bar_chart.dart';
import 'charts/word_length_bar_chart.dart';

class TopChoices extends StatelessWidget {
  const TopChoices({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          color: Color.fromARGB(66, 224, 224, 224),
          thickness: 2,
          endIndent: 40,
          indent: 40,
        ),
        const SizedBox(height: 10),
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
        const Divider(
          color: Color.fromARGB(66, 224, 224, 224),
          thickness: 2,
          endIndent: 40,
          indent: 40,
        ),
      ],
    );
  }
}
