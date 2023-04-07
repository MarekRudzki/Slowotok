import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/src/services/constants.dart';
import '/src/services/words_provider.dart';

class SingleLetter extends StatelessWidget {
  final int index;
  final int letterIndex;

  const SingleLetter({
    super.key,
    required this.index,
    required this.letterIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeIn,
        width: 40,
        height: 50,
        child: Align(
          child: Text(
            context.watch<WordsProvider>().getLetter(index, letterIndex),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: buildBackgroundColor(context),
        ),
      ),
    );
  }

  Color buildBackgroundColor(BuildContext context) {
    final provider = context.watch<WordsProvider>();
    final correctWord = context.watch<WordsProvider>().correctWord;

    if (provider.status[index] == false) {
      return Constants.backgroundColor;
    } else {
      if (provider.guesses[index][letterIndex] == correctWord[letterIndex]) {
        return Constants.correctLetterColor;
      } else {
        if (correctWord.contains(provider.guesses[index][letterIndex])) {
          if (correctWord[
                  correctWord.indexOf(provider.guesses[index][letterIndex])] ==
              provider.guesses[index]
                  [correctWord.indexOf(provider.guesses[index][letterIndex])]) {
            return Constants.noLetterInWordColor;
          } else {
            return Constants.wrongLetterColor;
          }
        } else {
          return Constants.noLetterInWordColor;
        }
      }
    }
  }
}
