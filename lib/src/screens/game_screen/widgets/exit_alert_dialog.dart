import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/src/services/providers/stats_provider.dart';
import '/src/services/providers/words_provider.dart';

class ExitAlertDialog extends StatelessWidget {
  const ExitAlertDialog({
    super.key,
    required this.wordSolveAttempt,
    required this.provider,
  });

  final bool wordSolveAttempt;
  final WordsProvider provider;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Text(
        'Na pewno?',
        style: TextStyle(
          fontSize: 18,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Chcesz wyjść i opuścić te hasło?',
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            wordSolveAttempt
                ? 'Podjęto próbę rozwiązania hasła - gra zostanie zaliczona jako przegrana.'
                : 'Gra nie zostanie zaliczona jako przegrana.',
            style: TextStyle(
              color: wordSolveAttempt
                  ? Colors.red
                  : Theme.of(context).colorScheme.onError,
              fontSize: 15,
            ),
          )
        ],
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 15, 24, 0),
      actions: [
        TextButton(
          child: const Text(
            'Nie',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: const Text(
            'Tak',
            style: TextStyle(
              color: Colors.green,
            ),
          ),
          onPressed: () async {
            if (wordSolveAttempt) {
              await provider.markGameAsLost();

              if (provider.getGameMode() == 'wordsoftheday') {
                final int gameLevel = await provider.getCurrentGameLevel();
                await provider.setGameStatus(
                  gameLevel: gameLevel,
                  isWinner: false,
                );
              }
            }
            if (context.mounted) {
              Provider.of<StatsProvider>(context, listen: false)
                  .setDisplayedStatsType(statsType: 'wotd');
            }

            if (context.mounted) {
              Navigator.of(context).pop(true);
              await Provider.of<WordsProvider>(context, listen: false)
                  .restartWord();
            }
          },
        ),
      ],
    );
  }
}
