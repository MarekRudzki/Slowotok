import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../services/words_provider.dart';
import 'word_length_button.dart';

class WordLengthPicker extends StatelessWidget {
  const WordLengthPicker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Column(
        children: [
          Center(
            child: Text(
              'Wybierz długość słowa',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                WordLengthButton(
                  length: '4',
                  onPressed: () async {
                    Provider.of<WordsProvider>(context, listen: false)
                        .setWordLength(4);
                  },
                ),
                WordLengthButton(
                  length: '5',
                  onPressed: () async {
                    Provider.of<WordsProvider>(context, listen: false)
                        .setWordLength(5);
                  },
                ),
                WordLengthButton(
                  length: '6',
                  onPressed: () async {
                    Provider.of<WordsProvider>(context, listen: false)
                        .setWordLength(6);
                  },
                ),
                WordLengthButton(
                  length: '7',
                  onPressed: () async {
                    Provider.of<WordsProvider>(context, listen: false)
                        .setWordLength(7);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
