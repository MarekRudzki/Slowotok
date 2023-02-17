import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slowotok/src/services/constants.dart';
import 'package:slowotok/src/services/words_provider.dart';

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
        width: 44,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: selectedWordLength == tries
              ? Constants.correctLetterColor
              : Constants.noLetterInWordColor,
        ),
        child: Center(
          child: Text(
            tries,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
