import 'package:flutter/material.dart';

import 'package:charts_flutter_new/flutter.dart';

import '/src/services/providers/stats_provider.dart';

class TotalTriesBarChart extends StatelessWidget {
  const TotalTriesBarChart({
    required this.isDark,
    required this.statsProvider,
  });

  final bool isDark;
  final StatsProvider statsProvider;

  @override
  Widget build(BuildContext context) {
    int getCount({required int tries}) {
      return statsProvider.getGamesNumberForGivenTries(totalTries: tries);
    }

    final data = [
      _TotalTriesModel(
        tries: '4',
        count: getCount(tries: 4),
        color: const Color(r: 225, g: 193, b: 51),
      ),
      _TotalTriesModel(
        tries: '5',
        count: getCount(tries: 5),
        color: const Color(r: 225, g: 193, b: 51),
      ),
      _TotalTriesModel(
        tries: '6',
        count: getCount(tries: 6),
        color: const Color(r: 225, g: 193, b: 51),
      ),
    ];

    List<TickSpec<int>> getStaticTicks() {
      final List<int> counter = [
        getCount(tries: 4),
        getCount(tries: 6),
        getCount(tries: 6),
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
          Series<_TotalTriesModel, String>(
            id: 'word length stats',
            data: data,
            domainFn: (_TotalTriesModel stats, _) => stats.tries,
            measureFn: (_TotalTriesModel stats, _) => stats.count,
            colorFn: (_TotalTriesModel stats, _) => stats.color,
            labelAccessorFn: (_TotalTriesModel stats, _) =>
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

class _TotalTriesModel {
  final String tries;
  final int count;
  final Color color;

  _TotalTriesModel({
    required this.tries,
    required this.count,
    required this.color,
  });
}
