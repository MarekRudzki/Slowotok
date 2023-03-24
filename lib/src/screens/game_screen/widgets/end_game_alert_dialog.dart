import 'package:flutter/material.dart';

import '../../../services/words_provider.dart';
import '../../home_screen/home_screen.dart';

class EndGameAlertDialog extends StatelessWidget {
  const EndGameAlertDialog({
    super.key,
    required this.provider,
    required this.isWinner,
  });

  final WordsProvider provider;
  final bool isWinner;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: isWinner
          ? const Text(
              'Gratulacje!',
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
              ),
            )
          : const Text(
              'Próbuj dalej!',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 18,
              ),
            ),
      content: isWinner
          ? const Text(
              'Udało Ci się odgadnąć hasło.',
              style: TextStyle(
                fontSize: 15,
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Niestety tym razem się nie udało.',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                const Text(
                  'Poszukiwane hasło to:',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Text(
                  provider.correctWord,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
      actions: [
        TextButton(
          onPressed: () {
            provider.restartWord();
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          },
          child: const Text('Wyjdź do menu'),
        ),
        TextButton(
          onPressed: () async {
            provider.restartWord();
            await provider
                .getRandomWord(
                  context: context,
                )
                .then(
                  (_) => Navigator.of(context).pop(),
                );
          },
          child: const Text('Jeszcze raz!'),
        ),
      ],
    );
  }
}
