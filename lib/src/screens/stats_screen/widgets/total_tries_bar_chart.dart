import 'package:charts_flutter_new/flutter.dart';

import 'package:flutter/material.dart';

class _TotalTriesStats {
  final String tries;
  final int count;

  _TotalTriesStats({
    required this.tries,
    required this.count,
  });
}

class TotalTriesBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = [
      _TotalTriesStats(tries: '4', count: 11),
      _TotalTriesStats(tries: '5', count: 1),
      _TotalTriesStats(tries: '6', count: 21),
      _TotalTriesStats(tries: '7', count: 5),
    ];

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.45,
      child: BarChart(
        [
          Series<_TotalTriesStats, String>(
            id: 'word length stats',
            data: data,
            domainFn: (_TotalTriesStats stats, _) => stats.tries,
            measureFn: (_TotalTriesStats stats, _) => stats.count,
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
