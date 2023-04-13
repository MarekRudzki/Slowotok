import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/src/services/words_provider.dart';

class StartGameButton extends StatelessWidget {
  const StartGameButton({super.key});

  @override
  Widget build(BuildContext context) {
    final int wordLength = context.watch<WordsProvider>().selectedWordLength;
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
              : const Color.fromARGB(255, 99, 203, 105),
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
        final WordsProvider wordsProvider =
            Provider.of<WordsProvider>(context, listen: false);

        if (wordLength == 0 || wordTotalTries == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
              content: const Text(
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

        await wordsProvider
            .setRandomWord(
          context: context,
        )
            .then(
          (value) {
            wordsProvider.changeGameMode(newGameMode: 'unlimited');
            Navigator.of(context).pop();
            Navigator.pushNamed(context, 'game_screen');
          },
        );
      },
    );
  }
}
