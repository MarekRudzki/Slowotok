import 'package:flutter/material.dart';

import '../../services/words_provider.dart';

class StatsTypePicker extends StatelessWidget {
  const StatsTypePicker({
    super.key,
    required this.wordsProvider,
  });

  final WordsProvider wordsProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 5, 20, 10),
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 3,
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
                color: wordsProvider.currentStatsSelected == 'Overall'
                    ? Colors.green
                    : Colors.transparent,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(13),
                  topLeft: Radius.circular(13),
                ),
              ),
              width: MediaQuery.of(context).size.width * 0.35,
              child: const Center(
                child: Text(
                  'Ogólne',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            onTap: () {
              wordsProvider.setDisplayedStats(
                statsType: 'Overall',
              );
            },
          ),
          const VerticalDivider(
            color: Colors.purple,
            width: 3,
            thickness: 3,
          ),
          InkWell(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeIn,
              decoration: BoxDecoration(
                color: wordsProvider.currentStatsSelected == 'Detailed'
                    ? Colors.green
                    : Colors.transparent,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(13),
                  topRight: Radius.circular(13),
                ),
              ),
              width: MediaQuery.of(context).size.width * 0.35,
              child: const Center(
                child: Text(
                  'Szczegółowe',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            onTap: () {
              wordsProvider.setDisplayedStats(
                statsType: 'Detailed',
              );
            },
          )
        ],
      ),
    );
  }
}
