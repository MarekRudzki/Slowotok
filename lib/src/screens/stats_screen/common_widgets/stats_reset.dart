import 'package:flutter/material.dart';

import '/src/services/providers/stats_provider.dart';

class StatsReset extends StatelessWidget {
  const StatsReset({
    super.key,
    required this.statsProvider,
  });

  final StatsProvider statsProvider;

  @override
  Widget build(BuildContext context) {
    final int gamesPlayed = statsProvider.getNumberOfGames();
    return IconButton(
      icon: const Icon(
        Icons.restart_alt,
      ),
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
                'Czy na pewno chcesz zresetować wszystkie swoje statystyki? Tej operacji nie można cofnąć.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
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
                    if (gamesPlayed == 0) {
                      buildSnackBar(context: context, hasStats: false);
                    } else {
                      await statsProvider.resetStatistics();
                      if (context.mounted) {
                        buildSnackBar(context: context, hasStats: true);
                      }
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

void buildSnackBar({required BuildContext context, required bool hasStats}) {
  Navigator.of(context).pop();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(
        seconds: 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Text(
        hasStats
            ? 'Pomyślnie zresetowano statystyki'
            : 'Brak statystyk do zresetowania',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
    ),
  );
}
