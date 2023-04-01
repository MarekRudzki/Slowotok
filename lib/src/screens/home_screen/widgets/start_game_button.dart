import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../services/words_provider.dart';
import '../../game_screen/game_screen.dart';

class StartGameButton extends StatelessWidget {
  const StartGameButton({super.key});

  @override
  Widget build(BuildContext context) {
    final int wordLength = context.watch<WordsProvider>().wordLength;
    final int wordTotalTries =
        context.watch<WordsProvider>().selectedTotalTries;

    return InkWell(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: wordLength == 0 || wordTotalTries == 0
              ? Colors.grey
              : Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        child: const Text(
          'Graj',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      onTap: () async {
        if (wordLength == 0 || wordTotalTries == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
              content: Text(
                'Wybierz długość słowa i liczbę prób',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          );
          return;
        }
        await Provider.of<WordsProvider>(context, listen: false)
            .getRandomWord(
          context: context,
        )
            .then(
          (value) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WordleScreen(
                  wordToGuess: value,
                  wordLength: wordLength,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
