import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../services/words_provider.dart';
import '../../../services/constants.dart';

class WordLengthButton extends StatelessWidget {
  const WordLengthButton({
    super.key,
    required this.length,
    required this.onPressed,
  });

  final String length;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final String selectedWordLength =
        context.watch<WordsProvider>().wordLength.toString();
    return InkWell(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        width: 44,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: selectedWordLength == length
              ? Constants.correctLetterColor
              : Constants.noLetterInWordColor,
        ),
        child: Center(
          child: Text(
            length,
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
