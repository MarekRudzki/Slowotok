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
                              color: buildGameIndicatorColor(
                                dayOutput: dayStats[0],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              width: 11,
                              height: 11,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: buildGameIndicatorColor(
                                  dayOutput: dayStats[1],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 11,
                            height: 11,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: buildGameIndicatorColor(
                                dayOutput: dayStats[2],
                              ),
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
                            child: Text(
                              buildFirstButtonText(
                                  dayPerformance: dayPerformance),
                            ),
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

                              if (dayPerformance != 'unfinished') {
                                await statsProvider.resetDayStats();
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
                          ),
                        if (dayPerformance == 'unfinished')
                          ElevatedButton(
                            child: const Text(
                              'Od nowa',
                            ),
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

                              await statsProvider.resetDayStats();

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

Color buildGameIndicatorColor({required String dayOutput}) {
  if (dayOutput == 'no_data') {
    return Colors.grey;
  } else if (dayOutput == 'win') {
    return Colors.green;
  } else {
    return Colors.red;
  }
}

String buildHeaderText({required String dayPerformance}) {
  if (dayPerformance == 'perfect') {
    return 'Perfekcyjnie!';
  } else if (dayPerformance == 'unstarted') {
    return 'Brak statystyk';
  } else if (dayPerformance == 'unfinished') {
    return 'Dzień niekompletny';
  } else if (dayPerformance == 'almost-perfect') {
    return 'Prawie idealnie!';
  } else if (dayPerformance == 'not-bad') {
    return 'Nieźle!';
  } else {
    return 'Tym razem się nie udało';
  }
}

String buildBodyText({required String dayPerformance}) {
  if (dayPerformance == 'perfect') {
    return 'Udało Ci się odgadnąć wszystkie hasła.';
  } else if (dayPerformance == 'unfinished') {
    return 'Spróbuj dokończyć ten dzień lub zagraj od nowa.';
  } else {
    return 'Spróbujesz jeszcze raz?';
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
