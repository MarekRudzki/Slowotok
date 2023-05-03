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

    List<TickSpec<int>> getStaticTicks() {
      final List<int> counter = [
        statsBox.get('4_tries_game') as int,
        statsBox.get('5_tries_game') as int,
        statsBox.get('6_tries_game') as int,
      ];
      counter.sort();
      final int maxTries = counter.last;

      return [
        const TickSpec(0),
        TickSpec(int.parse((maxTries / 2).toStringAsFixed(0))),
        TickSpec(int.parse((maxTries / 4).toStringAsFixed(0))),
        TickSpec(maxTries),
      ];
    }

    return SizedBox(
      height: 210,
      width: MediaQuery.of(context).size.width * 0.455,
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
          tickProviderSpec: StaticNumericTickProviderSpec(
            getStaticTicks(),
          ),
          renderSpec: GridlineRendererSpec(
            labelStyle: TextStyleSpec(
              color: isDark ? MaterialPalette.white : MaterialPalette.black,
            ),
            lineStyle: LineStyleSpec(
              color: isDark
                  ? MaterialPalette.white
                  : const Color(r: 135, g: 131, b: 131),
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
