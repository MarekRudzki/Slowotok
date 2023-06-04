import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/src/services/providers/words_provider.dart';
import '/src/services/constants.dart';

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
    final double screenWidth = MediaQuery.of(context).size.width;
    final String selectedWordLength =
        context.watch<WordsProvider>().getSelectedTries().toString();

    return InkWell(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        width: screenWidth * 0.09,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: selectedWordLength == tries
              ? const Color.fromARGB(255, 99, 203, 105)
              : Constants.noLetterInWordColor,
        ),
        child: Center(
          child: Text(
            tries,
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
