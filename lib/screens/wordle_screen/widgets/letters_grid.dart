import 'package:flutter/material.dart';
import 'package:slowotok/screens/wordle_screen/widgets/single_letter.dart';

class LettersGrid extends StatelessWidget {
  const LettersGrid({
    super.key,
    required this.wordLength,
  });

  final int wordLength;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),
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
            else //TODO add 6 and 7 letter words handling
              const SingleLetter(index: 0, letterIndex: 4),
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
          ],
        ),
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
          ],
        ),
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
          ],
        ),
      ],
    );
  }
}
