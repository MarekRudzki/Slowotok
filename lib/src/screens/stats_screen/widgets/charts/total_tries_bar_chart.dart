import 'package:flutter/material.dart';

import 'package:charts_flutter_new/flutter.dart';
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
  const TotalTriesBarChart({
    required this.isDark,
  });

  final bool isDark;

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
      height: 210,
      width: 180,
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
          outsideLabelStyleSpec: TextStyleSpec(
            color: isDark ? MaterialPalette.white : MaterialPalette.black,
            fontSize: 13,
          ),
        ),
        primaryMeasureAxis: NumericAxisSpec(
          renderSpec: GridlineRendererSpec(
            labelStyle: TextStyleSpec(
              color: isDark ? MaterialPalette.white : MaterialPalette.black,
            ),
          ),
        ),
        domainAxis: OrdinalAxisSpec(
          showAxisLine: false,
          renderSpec: SmallTickRendererSpec(
            labelStyle: TextStyleSpec(
              color: isDark ? MaterialPalette.white : MaterialPalette.black,
            ),
          ),
        ),
      ),
    );
  }
}
