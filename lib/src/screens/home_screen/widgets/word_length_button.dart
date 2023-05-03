import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/src/services/providers/words_provider.dart';
import '/src/services/constants.dart';

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
        context.watch<WordsProvider>().selectedWordLength.toString();

    return InkWell(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        width: 34,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: selectedWordLength == length
              ? const Color.fromARGB(255, 99, 203, 105)
              : Constants.noLetterInWordColor,
        ),
        child: Center(
          child: Text(
            length,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
