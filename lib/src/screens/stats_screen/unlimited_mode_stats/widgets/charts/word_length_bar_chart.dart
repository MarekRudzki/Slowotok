import 'package:charts_flutter_new/flutter.dart';

import 'package:flutter/material.dart';

import '/src/services/providers/stats_provider.dart';

class WordLengthBarChart extends StatelessWidget {
  const WordLengthBarChart({
    required this.isDark,
    required this.statsProvider,
  });

  final bool isDark;
  final StatsProvider statsProvider;

  @override
  Widget build(BuildContext context) {
    int getCount({required int wordLength}) {
      return statsProvider.getGamesNumberForGivenLength(wordLength: wordLength);
    }

    final data = [
      _WordLengthStatsModel(
        length: '4',
        count: getCount(wordLength: 4),
        color: const Color(r: 76, g: 175, b: 80),
      ),
      _WordLengthStatsModel(
        length: '5',
        count: getCount(wordLength: 5),
        color: const Color(r: 76, g: 175, b: 80),
      ),
      _WordLengthStatsModel(
        length: '6',
        count: getCount(wordLength: 6),
        color: const Color(r: 76, g: 175, b: 80),
      ),
      _WordLengthStatsModel(
        length: '7',
        count: getCount(wordLength: 7),
        color: const Color(r: 76, g: 175, b: 80),
      ),
    ];

    List<TickSpec<int>> getStaticTicks() {
      final List<int> counter = [
        getCount(wordLength: 4),
        getCount(wordLength: 5),
        getCount(wordLength: 6),
        getCount(wordLength: 7),
      ];
      counter.sort();
      final int maxLength = counter.last;

      return [
        const TickSpec(0),
        TickSpec(int.parse((maxLength / 2).toStringAsFixed(0))),
        TickSpec(int.parse((maxLength / 4).toStringAsFixed(0))),
        TickSpec(maxLength),
      ];
    }

    return SizedBox(
      height: 210,
      width: MediaQuery.of(context).size.width * 0.455,
      child: BarChart(
        [
          Series<_WordLengthStatsModel, String>(
            id: 'word length stats',
            data: data,
            domainFn: (_WordLengthStatsModel stats, _) => stats.length,
            measureFn: (_WordLengthStatsModel stats, _) => stats.count,
            colorFn: (_WordLengthStatsModel stats, _) => stats.color,
            labelAccessorFn: (_WordLengthStatsModel stats, _) =>
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
          showAxisLine: false,
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

class _WordLengthStatsModel {
  final String length;
  final int count;
  final Color color;

  _WordLengthStatsModel({
    required this.length,
    required this.count,
    required this.color,
  });
}
