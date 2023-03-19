import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:slowotok/src/screens/stats_screen/detailed_stats/widgets/win_percentage_bar_chart.dart';

class DetailedStatistics extends StatelessWidget {
  const DetailedStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    final statsBox = Hive.box('statsBox');

    return Column(
      children: [
        const WinPercentageBarChart(),
      ],
    );
  } //TODO add some stats
}
