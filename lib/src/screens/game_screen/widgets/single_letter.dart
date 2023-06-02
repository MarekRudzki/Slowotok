import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/src/services/providers/words_provider.dart';
import '/src/services/constants.dart';

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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * 0.12,
      height: screenHeight * 0.08,
      child: Padding(
        padding: const EdgeInsets.all(3.5),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeIn,
          child: Center(
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
      ),
    );
  }

  Color buildBackgroundColor(BuildContext context) {
    final provider = context.watch<WordsProvider>();
    final correctWord = context.watch<WordsProvider>().getCorrectWord();

    if (provider.getStatusList()[index] == false) {
      return Constants.backgroundColor;
    } else {
      if (provider.getGuessesList()[index][letterIndex] ==
          correctWord[letterIndex]) {
        return Constants.correctLetterColor;
      } else {
        if (correctWord
            .contains(provider.getGuessesList()[index][letterIndex])) {
          if (correctWord[correctWord
                  .indexOf(provider.getGuessesList()[index][letterIndex])] ==
              provider.getGuessesList()[index][correctWord
                  .indexOf(provider.getGuessesList()[index][letterIndex])]) {
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
