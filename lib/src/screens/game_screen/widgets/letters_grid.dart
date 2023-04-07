import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/src/services/words_provider.dart';
import 'single_letter.dart';

class LettersGrid extends StatelessWidget {
  const LettersGrid({
    super.key,
    required this.wordLength,
  });

  final int wordLength;

  @override
  Widget build(BuildContext context) {
    final int totalTries =
        Provider.of<WordsProvider>(context, listen: false).selectedTotalTries;

    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SingleLetter(index: 0, letterIndex: 0),
            const SingleLetter(index: 0, letterIndex: 1),
            const SingleLetter(index: 0, letterIndex: 2),
            const SingleLetter(index: 0, letterIndex: 3),
            if (wordLength == 4)
              const SizedBox.shrink()
            else
              const SingleLetter(index: 0, letterIndex: 4),
            if (wordLength == 6 || wordLength == 7)
              const SingleLetter(index: 0, letterIndex: 5),
            if (wordLength == 7) const SingleLetter(index: 0, letterIndex: 6),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SingleLetter(index: 1, letterIndex: 0),
            const SingleLetter(index: 1, letterIndex: 1),
            const SingleLetter(index: 1, letterIndex: 2),
            const SingleLetter(index: 1, letterIndex: 3),
            if (wordLength == 4)
              const SizedBox.shrink()
            else
              const SingleLetter(index: 1, letterIndex: 4),
            if (wordLength == 6 || wordLength == 7)
              const SingleLetter(index: 1, letterIndex: 5),
            if (wordLength == 7) const SingleLetter(index: 1, letterIndex: 6),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SingleLetter(index: 2, letterIndex: 0),
            const SingleLetter(index: 2, letterIndex: 1),
            const SingleLetter(index: 2, letterIndex: 2),
            const SingleLetter(index: 2, letterIndex: 3),
            if (wordLength == 4)
              const SizedBox.shrink()
            else
              const SingleLetter(index: 2, letterIndex: 4),
            if (wordLength == 6 || wordLength == 7)
              const SingleLetter(index: 2, letterIndex: 5),
            if (wordLength == 7) const SingleLetter(index: 2, letterIndex: 6),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SingleLetter(index: 3, letterIndex: 0),
            const SingleLetter(index: 3, letterIndex: 1),
            const SingleLetter(index: 3, letterIndex: 2),
            const SingleLetter(index: 3, letterIndex: 3),
            if (wordLength == 4)
              const SizedBox.shrink()
            else
              const SingleLetter(index: 3, letterIndex: 4),
            if (wordLength == 6 || wordLength == 7)
              const SingleLetter(index: 3, letterIndex: 5),
            if (wordLength == 7) const SingleLetter(index: 3, letterIndex: 6),
          ],
        ),
        if (totalTries == 5 || totalTries == 6)
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SingleLetter(index: 4, letterIndex: 0),
              const SingleLetter(index: 4, letterIndex: 1),
              const SingleLetter(index: 4, letterIndex: 2),
              const SingleLetter(index: 4, letterIndex: 3),
              if (wordLength == 4)
                const SizedBox.shrink()
              else
                const SingleLetter(index: 4, letterIndex: 4),
              if (wordLength == 6 || wordLength == 7)
                const SingleLetter(index: 4, letterIndex: 5),
              if (wordLength == 7) const SingleLetter(index: 4, letterIndex: 6),
            ],
          )
        else
          const SizedBox.shrink(),
        if (totalTries == 6)
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SingleLetter(index: 5, letterIndex: 0),
              const SingleLetter(index: 5, letterIndex: 1),
              const SingleLetter(index: 5, letterIndex: 2),
              const SingleLetter(index: 5, letterIndex: 3),
              if (wordLength == 4)
                const SizedBox.shrink()
              else
                const SingleLetter(index: 5, letterIndex: 4),
              if (wordLength == 6 || wordLength == 7)
                const SingleLetter(index: 5, letterIndex: 5),
              if (wordLength == 7) const SingleLetter(index: 5, letterIndex: 6),
            ],
          )
        else
          const SizedBox.shrink()
      ],
    );
  }
}
