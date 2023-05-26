import 'package:flutter/material.dart';

import 'package:charts_flutter_new/flutter.dart';

import '/src/services/providers/stats_provider.dart';

class WinLosePieChart extends StatefulWidget {
  const WinLosePieChart({
    super.key,
    required this.isDark,
    required this.statsProvider,
  });

  final bool isDark;
  final StatsProvider statsProvider;

  @override
  _WinLosePieChartState createState() => _WinLosePieChartState();
}

class _WinLosePieChartState extends State<WinLosePieChart> {
  @override
  Widget build(BuildContext context) {
    final int gamesWon = widget.statsProvider.getGamesWon();
    final int allGames = widget.statsProvider.getNumberOfGames();

    // Data to render
    final List<_WinLoseModel> _data = [
      _WinLoseModel(
        status: 'Wygrane',
        counter: gamesWon,
        color: const Color(r: 76, g: 175, b: 80),
        style: const TextStyleSpec(
          fontSize: 18,
          color: Color.white,
        ),
      ),
      _WinLoseModel(
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
      height: 180,
      child: PieChart<String>(
        [
          Series<_WinLoseModel, String>(
            id: 'Win-lose stats',
            colorFn: (_WinLoseModel stats, _) => stats.color,
            domainFn: (_WinLoseModel stats, _) => stats.status,
            measureFn: (_WinLoseModel stats, _) => stats.counter,
            data: _data,
            labelAccessorFn: (_WinLoseModel stats, _) =>
                stats.counter.toString(),
            insideLabelStyleAccessorFn: (_WinLoseModel stats, _) => stats.style,
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
              outsideLabelStyleSpec: TextStyleSpec(
                fontSize: 15,
                color: widget.isDark ? Color.white : Color.black,
              ),
            ),
          ],
        ),
        behaviors: [
          DatumLegend(
            position: BehaviorPosition.end,
            cellPadding: const EdgeInsets.only(right: 45, top: 35),
            outsideJustification: OutsideJustification.middleDrawArea,
            entryTextStyle: TextStyleSpec(
              fontSize: 13,
              color: widget.isDark ? Color.white : Color.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _WinLoseModel {
  final String status;
  final int counter;
  final Color color;
  final TextStyleSpec style;

  const _WinLoseModel({
    required this.status,
    required this.counter,
    required this.color,
    required this.style,
  });
}
