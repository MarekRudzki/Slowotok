import 'package:charts_flutter_new/flutter.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class _WordLengthStats {
  final String length;
  final int count;
  final Color color;

  _WordLengthStats({
    required this.length,
    required this.count,
    required this.color,
  });
}

class WordLengthBarChart extends StatelessWidget {
  const WordLengthBarChart({
    required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final statsBox = Hive.box('statsBox');
    final data = [
      _WordLengthStats(
        length: '4',
        count: statsBox.get('4_letter_game') as int,
        color: const Color(r: 76, g: 175, b: 80),
      ),
      _WordLengthStats(
        length: '5',
        count: statsBox.get('5_letter_game') as int,
        color: const Color(r: 76, g: 175, b: 80),
      ),
      _WordLengthStats(
        length: '6',
        count: statsBox.get('6_letter_game') as int,
        color: const Color(r: 76, g: 175, b: 80),
      ),
      _WordLengthStats(
        length: '7',
        count: statsBox.get('7_letter_game') as int,
        color: const Color(r: 76, g: 175, b: 80),
      ),
    ];

    return SizedBox(
      height: 210,
      width: MediaQuery.of(context).size.width * 0.455,
      child: BarChart(
        [
          Series<_WordLengthStats, String>(
            id: 'word length stats',
            data: data,
            domainFn: (_WordLengthStats stats, _) => stats.length,
            measureFn: (_WordLengthStats stats, _) => stats.count,
            colorFn: (_WordLengthStats stats, _) => stats.color,
            labelAccessorFn: (_WordLengthStats stats, _) =>
                stats.count.toString(),
          ),
        ],
        animate: true,
        animationDuration: const Duration(milliseconds: 1300),
        barRendererDecorator: BarLabelDecorator<String>(
          outsideLabelStyleSpec: TextStyleSpec(
            color: isDark ? MaterialPalette.white : MaterialPalette.black,
          ),
        ),
        primaryMeasureAxis: NumericAxisSpec(
          showAxisLine: false,
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
