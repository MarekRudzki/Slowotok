import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '/src/services/words_provider.dart';

class StatsReset extends StatelessWidget {
  const StatsReset({
    super.key,
    required this.wordsProvider,
  });

  final WordsProvider wordsProvider;

  @override
  Widget build(BuildContext context) {
    final statsBox = Hive.box('statsBox');
    final int gamesPlayed = statsBox.get('game_counter') as int;

    return IconButton(
      icon: const Icon(Icons.restart_alt),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.background,
              title: Text(
                'Reset statystyk',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              content: Text(
                'Czy na pewno chcesz zresetować swoje statystyki? Tej operacji nie można cofnąć.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              actions: [
                TextButton(
                  child: const Text(
                    'Nie',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text(
                    'Tak',
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
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
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
