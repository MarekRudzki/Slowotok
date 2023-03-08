import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../services/words_provider.dart';
import '../../services/constants.dart';
import 'detailed_stats/detailed_statistics.dart';
import 'overall_stats/overall_statistics.dart';
import 'stats_type_picker.dart';
import 'no_statistics.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final statsBox = Hive.box('statsBox');
    final int hasStats = statsBox.get('game_counter') as int;

    return SafeArea(
      child: Consumer<WordsProvider>(
        builder: (context, wordsProvider, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Statystyki'),
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  wordsProvider.currentStatsSelected = 'Overall';
                },
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
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
                    return const NoStatistics();
                  } else {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        StatsTypePicker(
                          wordsProvider: wordsProvider,
                        ),
                        if (wordsProvider.currentStatsSelected == 'Overall')
                          const OverallStatistics()
                        else
                          const DetailedStatistics(),
                      ],
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
