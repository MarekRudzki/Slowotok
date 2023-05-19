import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/services/providers/stats_provider.dart';
import '/src/services/providers/words_provider.dart';

class SingleDayStats extends StatelessWidget {
  const SingleDayStats({
    super.key,
    required this.statsProvider,
  });

  final StatsProvider statsProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: const Color.fromARGB(67, 163, 162, 162),
        child: Column(
          children: [
            Text(
              statsProvider
                  .getSelectedDateFormatted(statsProvider.getSelectedDay()),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Builder(
              builder: (context) {
                final List<String> dayStats = statsProvider.getSingleDayStats();
                final String dayPerformance = statsProvider.getDayPerformance();
                final WordsProvider wordsProvider =
                    Provider.of<WordsProvider>(context, listen: false);

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 11,
                            height: 11,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: dayStats[0] == 'no_data'
                                  ? Colors.grey
                                  : dayStats[0] == 'win'
                                      ? Colors.green
                                      : Colors.red,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              width: 11,
                              height: 11,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: dayStats[1] == 'no_data'
                                    ? Colors.grey
                                    : dayStats[1] == 'win'
                                        ? Colors.green
                                        : Colors.red,
                              ),
                            ),
                          ),
                          Container(
                            width: 11,
                            height: 11,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: dayStats[2] == 'no_data'
                                  ? Colors.grey
                                  : dayStats[2] == 'win'
                                      ? Colors.green
                                      : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      buildHeaderText(dayPerformance: dayPerformance),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (dayPerformance != 'unstarted')
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          buildBodyText(dayPerformance: dayPerformance),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (dayPerformance != 'perfect')
                          ElevatedButton(
                            onPressed: () async {
                              if (statsProvider
                                      .getSelectedDay()
                                      .toString()
                                      .substring(0, 10) ==
                                  DateTime.now().toString().substring(0, 10)) {
                                wordsProvider.changeMissedDayStatus(
                                    playingMissedDay: false);
                              } else {
                                wordsProvider.changeMissedDayStatus(
                                    playingMissedDay: true);
                              }
                              wordsProvider.playWotdMode(
                                  date: statsProvider.getSelectedDay());

                              if (context.mounted)
                                await wordsProvider
                                    .setRandomWord(
                                  context: context,
                                )
                                    .then(
                                  (value) {
                                    Navigator.pushNamed(context, 'game_screen');
                                  },
                                );
                            },
                            child: Text(
                              buildFirstButtonText(
                                  dayPerformance: dayPerformance),
                            ),
                          ),
                        if (dayPerformance == 'unfinished')
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text(
                              'Od nowa',
                            ),
                          ),
                      ],
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

String buildHeaderText({required String dayPerformance}) {
  if (dayPerformance == 'perfect') {
    return 'Perfekcyjnie!';
  } else if (dayPerformance == 'unstarted') {
    return 'Brak statystyk';
  } else if (dayPerformance == 'unfinished') {
    return 'Dzień niekompletny';
  } else {
    return 'Trochę brakuje';
  }
}

String buildBodyText({required String dayPerformance}) {
  if (dayPerformance == 'perfect') {
    return 'Udało Ci się odgadnąć wszystkie hasła.';
  } else if (dayPerformance == 'unfinished') {
    return 'Spróbuj dokończyć ten dzień lub zagraj od nowa.';
  } else {
    return 'Popraw swój wynik!';
  }
}

String buildFirstButtonText({required String dayPerformance}) {
  if (dayPerformance == 'unstarted') {
    return 'Zagraj!';
  } else if (dayPerformance == 'unfinished') {
    return 'Kontynuuj';
  } else {
    return 'Powtórz dzień';
  }
}
