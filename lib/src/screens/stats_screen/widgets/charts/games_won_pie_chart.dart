import 'package:flutter/material.dart';

import 'package:charts_flutter_new/flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

class _WinLoseStats {
  final String status;
  final int counter;
  final Color color;
  final TextStyleSpec style;

  const _WinLoseStats({
    required this.status,
    required this.counter,
    required this.color,
    required this.style,
  });
}

class WinLosePieChart extends StatefulWidget {
  const WinLosePieChart({super.key});

  @override
  _WinLosePieChartState createState() => _WinLosePieChartState();
}

class _WinLosePieChartState extends State<WinLosePieChart> {
  @override
  Widget build(BuildContext context) {
    final statsBox = Hive.box('statsBox');
    final int gamesWon = statsBox.get('game_won') as int;
    final int allGames = statsBox.get('game_counter') as int;

    // Data to render
    final List<_WinLoseStats> _data = [
      _WinLoseStats(
        status: 'Wygrane',
        counter: gamesWon,
        color: const Color(r: 76, g: 175, b: 80),
        style: const TextStyleSpec(
          fontSize: 18,
          color: Color.white,
        ),
      ),
      _WinLoseStats(
        status: 'Przegrane',
        counter: allGames - gamesWon,
        color: const Color(r: 244, g: 67, b: 54),
        style: const TextStyleSpec(
          fontSize: 18,
          color: Color.white,
        ),
      ),
    ];

    return SizedBox(
      height: 215,
      child: PieChart<String>(
        [
          Series<_WinLoseStats, String>(
            id: 'Win-lose stats',
            colorFn: (_WinLoseStats stats, _) => stats.color,
            domainFn: (_WinLoseStats stats, _) => stats.status,
            measureFn: (_WinLoseStats stats, _) => stats.counter,
            data: _data,
            labelAccessorFn: (_WinLoseStats stats, _) =>
                stats.counter.toString(),
            insideLabelStyleAccessorFn: (_WinLoseStats stats, _) => stats.style,
          ),
        ],
        animate: true,
        animationDuration: const Duration(milliseconds: 1300),
        defaultRenderer: ArcRendererConfig(
          arcRendererDecorators: [
            ArcLabelDecorator(
              leaderLineColor: const Color(r: 156, g: 39, b: 176),
              leaderLineStyleSpec: ArcLabelLeaderLineStyleSpec(
                color: gamesWon > (allGames - gamesWon)
                    ? const Color(r: 244, g: 67, b: 54)
                    : const Color(r: 76, g: 175, b: 80),
                length: 20,
                thickness: 3,
              ),
              outsideLabelStyleSpec: const TextStyleSpec(
                fontSize: 15,
                color: Color.white,
              ),
            ),
          ],
        ),
        behaviors: [
          DatumLegend(
            position: BehaviorPosition.end,
            cellPadding: const EdgeInsets.only(right: 25, top: 35),
            outsideJustification: OutsideJustification.middleDrawArea,
            entryTextStyle: const TextStyleSpec(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
