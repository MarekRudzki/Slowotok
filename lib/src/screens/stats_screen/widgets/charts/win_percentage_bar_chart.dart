import 'package:charts_flutter_new/flutter.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:slowotok/src/services/constants.dart';

class _WinPercentage {
  _WinPercentage({
    required this.wordLength,
    required this.percentage,
    required this.color,
  });

  final String wordLength;
  final int percentage;
  final Color color;
}

class WinPercentageBarChart extends StatelessWidget {
  const WinPercentageBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final statsBox = Hive.box('statsBox');

    int getStats({required int wordLength, required int totalTries}) {
      final int totalGames =
          statsBox.get('${wordLength}_${totalTries}_game') as int;
      final int gamesWon =
          statsBox.get('${wordLength}_${totalTries}_won') as int;

      if (totalGames == 0) {
        return 0;
      } else {
        return ((gamesWon / totalGames) * 100).round();
      }
    }

    final fourTries = [
      _WinPercentage(
          wordLength: '4',
          percentage: getStats(totalTries: 4, wordLength: 4),
          color: Color.fromOther(
              color: Color.fromHex(code: Constants.fourGuessesColor))),
      _WinPercentage(
          wordLength: '5',
          percentage: getStats(totalTries: 4, wordLength: 5),
          color: Color.fromOther(
              color: Color.fromHex(code: Constants.fourGuessesColor))),
      _WinPercentage(
          wordLength: '6',
          percentage: getStats(totalTries: 4, wordLength: 6),
          color: Color.fromOther(
              color: Color.fromHex(code: Constants.fourGuessesColor))),
      _WinPercentage(
          wordLength: '7',
          percentage: getStats(totalTries: 4, wordLength: 7),
          color: Color.fromOther(
              color: Color.fromHex(code: Constants.fourGuessesColor))),
    ];
    final fiveTries = [
      _WinPercentage(
          wordLength: '4',
          percentage: getStats(totalTries: 5, wordLength: 4),
          color: Color.fromOther(
              color: Color.fromHex(code: Constants.fiveGuessesColor))),
      _WinPercentage(
          wordLength: '5',
          percentage: getStats(totalTries: 5, wordLength: 5),
          color: Color.fromOther(
              color: Color.fromHex(code: Constants.fiveGuessesColor))),
      _WinPercentage(
          wordLength: '6',
          percentage: getStats(totalTries: 5, wordLength: 6),
          color: Color.fromOther(
              color: Color.fromHex(code: Constants.fiveGuessesColor))),
      _WinPercentage(
          wordLength: '7',
          percentage: getStats(totalTries: 5, wordLength: 7),
          color: Color.fromOther(
              color: Color.fromHex(code: Constants.fiveGuessesColor))),
    ];
    final sixTries = [
      _WinPercentage(
          wordLength: '4',
          percentage: getStats(totalTries: 6, wordLength: 4),
          color: Color.fromOther(
              color: Color.fromHex(code: Constants.sixGuessesColor))),
      _WinPercentage(
          wordLength: '5',
          percentage: getStats(totalTries: 6, wordLength: 5),
          color: Color.fromOther(
              color: Color.fromHex(code: Constants.sixGuessesColor))),
      _WinPercentage(
          wordLength: '6',
          percentage: getStats(totalTries: 6, wordLength: 6),
          color: Color.fromOther(
              color: Color.fromHex(code: Constants.sixGuessesColor))),
      _WinPercentage(
          wordLength: '7',
          percentage: getStats(totalTries: 6, wordLength: 7),
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
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: BarChart(
              barGroupingType: BarGroupingType.grouped,
              animate: true,
              animationDuration: const Duration(milliseconds: 1300),
              primaryMeasureAxis: NumericAxisSpec(
                tickProviderSpec: StaticNumericTickProviderSpec(
                  staticTicks,
                ),
                renderSpec: const GridlineRendererSpec(
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
              [
                Series<_WinPercentage, String>(
                  id: 'Cztery próby',
                  data: fourTries,
                  domainFn: (_WinPercentage wins, _) => wins.wordLength,
                  measureFn: (_WinPercentage wins, _) => wins.percentage,
                  colorFn: (_WinPercentage wins, _) => wins.color,
                ),
                Series<_WinPercentage, String>(
                  id: 'Pięć prób',
                  data: fiveTries,
                  domainFn: (_WinPercentage wins, _) => wins.wordLength,
                  measureFn: (_WinPercentage wins, _) => wins.percentage,
                  colorFn: (_WinPercentage wins, _) => wins.color,
                ),
                Series<_WinPercentage, String>(
                  id: 'Sześć prób',
                  data: sixTries,
                  domainFn: (_WinPercentage wins, _) => wins.wordLength,
                  measureFn: (_WinPercentage wins, _) => wins.percentage,
                  colorFn: (_WinPercentage wins, _) => wins.color,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
