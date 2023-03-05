import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '../../services/constants.dart';
import 'overall_stats/overall_statistics.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final statsBox = Hive.box('statsBox');
    final int hasStats = statsBox.get('game_counter') as int;

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
          child: Builder(
            builder: (context) {
              if (hasStats == 0) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Brak statystyk!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Zagraj',
                            style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Text(
                          'lub',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            //TODO
                          },
                          child: const Text(
                            'importuj',
                            style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Text(
                          'statystyki aby je wyświetlić.',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                  ],
                );
              } else {
                return const OverallStatistics();
              }
            },
          ),
        ),
      ),
    );
  }
}
