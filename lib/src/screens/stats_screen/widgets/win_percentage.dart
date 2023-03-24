import 'package:flutter/material.dart';

import 'charts/win_percentage_bar_chart.dart';

class WinPercentage extends StatelessWidget {
  const WinPercentage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Center(
            child: Text(
              'Wygrane (%) dla poszczególnej długości słów',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
        ),
        const WinPercentageBarChart(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  color: const Color.fromRGBO(244, 67, 54, 1),
                  height: 12,
                  width: 12,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Cztery próby',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  color: const Color.fromRGBO(225, 193, 51, 1),
                  height: 12,
                  width: 12,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Pięć prób',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  color: const Color.fromRGBO(76, 175, 80, 1),
                  height: 12,
                  width: 12,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Sześć prób',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }
}
