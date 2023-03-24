import 'package:charts_flutter_new/flutter.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class _TotalTriesStats {
  final String tries;
  final int count;
  final Color color;

  _TotalTriesStats({
    required this.tries,
    required this.count,
    required this.color,
  });
}

class TotalTriesBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final statsBox = Hive.box('statsBox');
    final data = [
      _TotalTriesStats(
        tries: '4',
        count: statsBox.get('4_tries_game') as int,
        color: const Color(r: 225, g: 193, b: 51),
      ),
      _TotalTriesStats(
        tries: '5',
        count: statsBox.get('5_tries_game') as int,
        color: const Color(r: 225, g: 193, b: 51),
      ),
      _TotalTriesStats(
        tries: '6',
        count: statsBox.get('6_tries_game') as int,
        color: const Color(r: 225, g: 193, b: 51),
      ),
    ];

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width * 0.42,
      child: BarChart(
        [
          Series<_TotalTriesStats, String>(
            id: 'word length stats',
            data: data,
            domainFn: (_TotalTriesStats stats, _) => stats.tries,
            measureFn: (_TotalTriesStats stats, _) => stats.count,
            colorFn: (_TotalTriesStats stats, _) => stats.color,
            labelAccessorFn: (_TotalTriesStats stats, _) =>
                stats.count.toString(),
          ),
        ],
        animate: true,
        animationDuration: const Duration(milliseconds: 1300),
        barRendererDecorator: BarLabelDecorator<String>(
          outsideLabelStyleSpec: const TextStyleSpec(
            color: Color.white,
          ),
        ),
        primaryMeasureAxis: const NumericAxisSpec(
          renderSpec: GridlineRendererSpec(
            labelStyle: TextStyleSpec(
              color: MaterialPalette.white,
            ),
          ),
        ),
        domainAxis: const OrdinalAxisSpec(
          showAxisLine: false,
          renderSpec: SmallTickRendererSpec(
            labelStyle: TextStyleSpec(
              color: MaterialPalette.white,
            ),
          ),
        ),
      ),
    );
  }
}
