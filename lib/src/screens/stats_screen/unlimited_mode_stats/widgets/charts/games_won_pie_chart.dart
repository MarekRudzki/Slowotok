import 'package:flutter/material.dart';

import '/src/services/providers/stats_provider.dart';

import 'package:charts_flutter_new/flutter.dart' as charts;

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
        color: charts.ColorUtil.fromDartColor(const Color.fromARGB(255, 76, 175, 80)),
        style: const charts.TextStyleSpec(
          fontSize: 18,
          color: charts.Color.white,
        ),
      ),
      _WinLoseModel(
        status: 'Przegrane',
        counter: allGames - gamesWon,
        color: charts.ColorUtil.fromDartColor(const Color.fromARGB(255, 244, 67, 54)),
        style: const charts.TextStyleSpec(
          fontSize: 18,
          color: charts.Color.white,
        ),
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 180,
          width: 180,
          child: charts.PieChart<String>(
            [
              charts.Series<_WinLoseModel, String>(
                id: 'Win-lose stats',
                colorFn: (_WinLoseModel stats, _) => stats.color,
                domainFn: (_WinLoseModel stats, _) => stats.status,
                measureFn: (_WinLoseModel stats, _) => stats.counter,
                data: _data,
                labelAccessorFn: (_WinLoseModel stats, _) => stats.counter.toString(),
                insideLabelStyleAccessorFn: (_WinLoseModel stats, _) => stats.style,
              ),
            ],
            animate: true,
            animationDuration: const Duration(milliseconds: 1300),
            defaultRenderer: charts.ArcRendererConfig(
              arcRendererDecorators: [
                charts.ArcLabelDecorator(
                  leaderLineColor: const charts.Color(r: 156, g: 39, b: 176),
                  leaderLineStyleSpec: charts.ArcLabelLeaderLineStyleSpec(
                    color: gamesWon > (allGames - gamesWon)
                        ? const charts.Color(r: 244, g: 67, b: 54)
                        : const charts.Color(r: 76, g: 175, b: 80),
                    length: 20,
                    thickness: 3,
                  ),
                  outsideLabelStyleSpec: charts.TextStyleSpec(
                    fontSize: 15,
                    color: widget.isDark ? charts.Color.white : charts.Color.black,
                  ),
                ),
              ],
            ),
            behaviors: [],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(76, 175, 80, 1),
                  ),
                  width: 10,
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(
                    'Wygrane',
                    style: TextStyle(
                      fontSize: 14,
                      color: widget.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(244, 67, 54, 1),
                    ),
                    width: 10,
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      'Przegrane',
                      style: TextStyle(
                        fontSize: 14,
                        color: widget.isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _WinLoseModel {
  final String status;
  final int counter;
  final charts.Color color;
  final charts.TextStyleSpec style;

  _WinLoseModel({
    required this.status,
    required this.counter,
    required this.color,
    required this.style,
  });
}
