import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '/src/services/words_provider.dart';

class StatisticsOptions extends StatelessWidget {
  const StatisticsOptions({
    super.key,
    required this.wordsProvider,
  });

  final WordsProvider wordsProvider;

  @override
  Widget build(BuildContext context) {
    final statsBox = Hive.box('statsBox');
    final int gamesPlayed = statsBox.get('game_counter') as int;

    return PopupMenuButton(
      itemBuilder: (context) {
        return const [
          PopupMenuItem(
            child: Text(
              'Resetuj statystyki',
            ),
            value: 'reset',
          ),
          PopupMenuItem(
            child: Text(
              'Importuj statystyki',
            ),
            value: 'import',
          ),
          PopupMenuItem(
            child: Text(
              'Eksportuj statystyki',
            ),
            value: 'export',
          ),
        ];
      },
      onSelected: (value) {
        if (value == 'reset') {
          showDialog(
            context: context,
            builder: (context) {
              return StatsReset(
                wordsProvider: wordsProvider,
                gamesPlayed: gamesPlayed,
              );
            },
          );
        }
        if (value == 'import') {
          //TODO
        }
        if (value == 'export') {
          //TODO
        }
      },
    );
  }
}

class StatsReset extends StatelessWidget {
  const StatsReset({
    super.key,
    required this.wordsProvider,
    required this.gamesPlayed,
  });

  final WordsProvider wordsProvider;
  final int gamesPlayed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reset statystyk'),
      content: const Text('Czy na pewno chcesz zresetować swoje statystyki?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Nie',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            if (gamesPlayed != 0) {
              await wordsProvider.resetStatistics();
            }
            if (context.mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(
                    seconds: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                  content: Text(
                    gamesPlayed == 0
                        ? 'Brak statystyk do zresetowania'
                        : 'Pomyślnie zresetowano statystyki',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          child: const Text(
            'Tak',
            style: TextStyle(
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }
}
