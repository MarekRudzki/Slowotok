import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:slowotok/src/screens/stats_screen/widgets/games_won_pie_chart.dart';
import 'package:slowotok/src/screens/stats_screen/widgets/total_tries_bar_chart.dart';
import 'package:slowotok/src/screens/stats_screen/widgets/word_length_bar_chart.dart';

import '../../services/constants.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final statsBox = Hive.box('statsBox');

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Statystyki'),
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Constants.gradientBackgroundLighter,
                Constants.gradientBackgroundDarker,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Łączna liczba rozgrywek:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  statsBox.get('game_counter').toString(),
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
          ),
        ),
      ),
    );
  }
}
