import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../services/words_provider.dart';
import '../../../services/constants.dart';

class WordTotalTriesButton extends StatelessWidget {
  const WordTotalTriesButton({
    super.key,
    required this.tries,
    required this.onPressed,
  });

  final String tries;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final String selectedWordLength =
        context.watch<WordsProvider>().selectedTotalTries.toString();
    return InkWell(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        width: 34,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: selectedWordLength == tries
              ? Constants.correctLetterColor
              : Constants.noLetterInWordColor,
        ),
        child: Center(
          child: Text(
            tries,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
