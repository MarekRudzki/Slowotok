import 'package:flutter/material.dart';

import '/src/screens/game_screen/widgets/letter_tile.dart';
import '/src/services/providers/words_provider.dart';
import '/src/services/constants.dart';

class WordsOfTheDayGamesSummary extends StatelessWidget {
  const WordsOfTheDayGamesSummary({
    super.key,
    required this.provider,
    required this.correctWords,
    required this.currentWordLevel,
  });

  final WordsProvider provider;
  final List<String> correctWords;
  final int currentWordLevel;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: provider.getUserWords(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: snapshot.data![currentWordLevel].map((word) {
              if (word == '') {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ['', '', '', '', '']
                      .map(
                        (letter) => LetterTile(
                          letter: letter,
                          color: Constants.backgroundColor,
                        ),
                      )
                      .toList(),
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: word
                    .split('')
                    .map(
                      (letter) => LetterTile(
                        letter: letter,
                        color: buildBackgroundColor(
                          context,
                          wordGuess: word,
                          letterGuess: letter,
                          correctWord: correctWords[currentWordLevel],
                        ),
                      ),
                    )
                    .toList(),
              );
            }).toList(),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Color buildBackgroundColor(
    BuildContext context, {
    required String wordGuess,
    required String letterGuess,
    required String correctWord,
  }) {
    final List<String> guessWordLetters = wordGuess.split('').toList();
    final List<String> correctWordLetters = correctWord.split('').toList();

    late int testint;
    for (int i = 0; i < 5; i++) {
      if (letterGuess == guessWordLetters[i]) {
        testint = i;
        break;
      }
    }
    if (letterGuess == correctWordLetters[testint]) {
      return Constants.correctLetterColor;
    } else if (correctWordLetters.contains(letterGuess)) {
      return Constants.wrongLetterColor;
    } else if (letterGuess == ' ') {
      return Constants.backgroundColor;
    } else {
      return Constants.noLetterInWordColor;
    }
  }
}
