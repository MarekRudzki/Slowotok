import 'package:flutter/material.dart';

import 'package:charts_flutter_new/flutter.dart';

import '/src/services/providers/stats_provider.dart';
import '/src/services/constants.dart';

class WinPercentageBarChart extends StatelessWidget {
  const WinPercentageBarChart({
    super.key,
    required this.isDark,
    required this.statsProvider,
  });

  final bool isDark;
  final StatsProvider statsProvider;

  @override
  Widget build(BuildContext context) {
    int getCount({required int wordLength, required int totalTries}) {
      final int totalGames = statsProvider.getGamesForGivenLengthAndTries(
        wordLength: wordLength,
        totalTries: totalTries,
      );
      final int gamesWon = statsProvider.getWonGamesForGivenLengthAndTries(
        wordLength: wordLength,
        totalTries: totalTries,
      );

      if (totalGames == 0) {
        return 0;
      } else {
        return ((gamesWon / totalGames) * 100).round();
      }
    }

    final fourTries = [
      _WinPercentageModel(
          wordLength: '4',
          percentage: getCount(totalTries: 4, wordLength: 4),
          color: Color.fromOther(
              color: Color.fromHex(code: Constants.fourGuessesColor))),
      _WinPercentageModel(
          wordLength: '5',
          percentage: getCount(totalTries: 4, wordLength: 5),
          color: Color.fromOther(
              color: Color.fromHex(code: Constants.fourGuessesColor))),
      _WinPercentageModel(
          wordLength: '6',
          percentage: getCount(totalTries: 4, wordLength: 6),
          color: Color.fromOther(
              color: Color.fromHex(code: Constants.fourGuessesColor))),
      _WinPercentageModel(
          wordLength: '7',
          percentage: getCount(totalTries: 4, wordLength: 7),
          color: Color.fromOther(
              color: Color.fromHex(code: Constants.fourGuessesColor))),
    ];
    final fiveTries = [
      _WinPercentageModel(
          wordLength: '4',
          percentage: getCount(totalTries: 5, wordLength: 4),
          color: Color.fromOther(
              color: Color.fromHex(code: Constants.fiveGuessesColor))),
      _WinPercentageModel(
          wordLength: '5',
          percentage: getCount(totalTries: 5, wordLength: 5),
          color: Color.fromOther(
              color: Color.fromHex(code: Constants.fiveGuessesColor))),
      _WinPercentageModel(
          wordLength: '6',
          percentage: getCount(totalTries: 5, wordLength: 6),
          color: Color.fromOther(
              color: Color.fromHex(code: Constants.fiveGuessesColor))),
      _WinPercentageModel(
          wordLength: '7',
          percentage: getCount(totalTries: 5, wordLength: 7),
          color: Color.fromOther(
              color: Color.fromHex(code: Constants.fiveGuessesColor))),
    ];
    final sixTries = [
      _WinPercentageModel(
          wordLength: '4',
          percentage: getCount(totalTries: 6, wordLength: 4),
          color: Color.fromOther(
              color: Color.fromHex(code: Constants.sixGuessesColor))),
      _WinPercentageModel(
          wordLength: '5',
          percentage: getCount(totalTries: 6, wordLength: 5),
          color: Color.fromOther(
              color: Color.fromHex(code: Constants.sixGuessesColor))),
      _WinPercentageModel(
          wordLength: '6',
          percentage: getCount(totalTries: 6, wordLength: 6),
          color: Color.fromOther(
              color: Color.fromHex(code: Constants.sixGuessesColor))),
      _WinPercentageModel(
          wordLength: '7',
          percentage: getCount(totalTries: 6, wordLength: 7),
          color: Color.fromOther(
              color: Color.fromHex(code: Constants.sixGuessesColor))),
    ];

    final staticTicks = <TickSpec<int>>[
      const TickSpec(0),
      const TickSpec(25),
      const TickSpec(50),
      const TickSpec(75),
      const TickSpec(100),
    ];

    return Padding(
      padding: const EdgeInsets.all(15),
      child: SizedBox(
        height: 200,
        child: BarChart(
          barGroupingType: BarGroupingType.grouped,
          animate: true,
          animationDuration: const Duration(milliseconds: 1300),
          primaryMeasureAxis: NumericAxisSpec(
            tickProviderSpec: StaticNumericTickProviderSpec(
              staticTicks,
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
          [
            Series<_WinPercentageModel, String>(
              id: 'Cztery próby',
              data: fourTries,
              domainFn: (_WinPercentageModel wins, _) => wins.wordLength,
              measureFn: (_WinPercentageModel wins, _) => wins.percentage,
              colorFn: (_WinPercentageModel wins, _) => wins.color,
            ),
            Series<_WinPercentageModel, String>(
              id: 'Pięć prób',
              data: fiveTries,
              domainFn: (_WinPercentageModel wins, _) => wins.wordLength,
              measureFn: (_WinPercentageModel wins, _) => wins.percentage,
              colorFn: (_WinPercentageModel wins, _) => wins.color,
            ),
            Series<_WinPercentageModel, String>(
              id: 'Sześć prób',
              data: sixTries,
              domainFn: (_WinPercentageModel wins, _) => wins.wordLength,
              measureFn: (_WinPercentageModel wins, _) => wins.percentage,
              colorFn: (_WinPercentageModel wins, _) => wins.color,
            ),
          ],
        ),
      ),
    );
  }
}

class _WinPercentageModel {
  _WinPercentageModel({
    required this.wordLength,
    required this.percentage,
    required this.color,
  });

  final String wordLength;
  final int percentage;
  final Color color;
}
