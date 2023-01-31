import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/services/constants.dart';
import '/services/words_provider.dart';

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
        width: 44,
        height: 54,
        child: Align(
          child: Text(
            context.watch<WordsProvider>().getItem(index, letterIndex),
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
    if (context.watch<WordsProvider>().status[index] == false) {
      return Constants.backgroundColor;
    } else {
      if (context.watch<WordsProvider>().guesses[index][letterIndex] ==
          context.watch<WordsProvider>().correctWord[letterIndex]) {
        return Constants.correctLetterColor;
      } else {
        if (context.watch<WordsProvider>().correctWord.contains(
            context.watch<WordsProvider>().guesses[index][letterIndex])) {
          if (context.watch<WordsProvider>().correctWord[context
                  .watch<WordsProvider>()
                  .correctWord
                  .indexOf(context.watch<WordsProvider>().guesses[index]
                      [letterIndex])] ==
              context.watch<WordsProvider>().guesses[index][context
                  .watch<WordsProvider>()
                  .correctWord
                  .indexOf(context.watch<WordsProvider>().guesses[index]
                      [letterIndex])]) {
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
