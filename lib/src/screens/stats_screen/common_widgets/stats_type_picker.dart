import 'package:flutter/material.dart';

import '/src/services/providers/stats_provider.dart';

class StatsTypePicker extends StatelessWidget {
  const StatsTypePicker({
    super.key,
    required this.statsProvider,
  });

  final StatsProvider statsProvider;

  @override
  Widget build(BuildContext context) {
    final bool isUnlimited =
        statsProvider.getDisplayedStatsType() == 'unlimited';
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeIn,
              decoration: BoxDecoration(
                color: isUnlimited
                    ? Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer
                        .withOpacity(0.5)
                    : const Color.fromRGBO(235, 235, 235, 1),
              ),
              width: MediaQuery.of(context).size.width * 0.40,
              child: Center(
                child: Text(
                  'Tryb nieograniczony',
                  style: TextStyle(
                    fontWeight: isUnlimited ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            ),
            onTap: () {
              statsProvider.setDisplayedStatsType(
                statsType: 'unlimited',
              );
            },
          ),
          const VerticalDivider(
            color: Colors.green,
            width: 2,
            thickness: 2,
          ),
          InkWell(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeIn,
              decoration: BoxDecoration(
                color: isUnlimited
                    ? const Color.fromRGBO(235, 235, 235, 1)
                    : Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer
                        .withOpacity(0.5),
              ),
              width: MediaQuery.of(context).size.width * 0.40,
              child: Center(
                child: Text(
                  'Słówka dnia',
                  style: TextStyle(
                    fontWeight: isUnlimited ? FontWeight.w400 : FontWeight.w700,
                  ),
                ),
              ),
            ),
            onTap: () {
              statsProvider.setDisplayedStatsType(
                statsType: 'wotd',
              );
            },
          )
        ],
      ),
    );
  }
}
