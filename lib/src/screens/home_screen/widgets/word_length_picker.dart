import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/src/services/providers/words_provider.dart';
import 'word_length_button.dart';

class WordLengthPicker extends StatelessWidget {
  const WordLengthPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final wordLengthList = [4, 5, 6, 7];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Center(
            child: Text(
              'Wybierz długość słowa',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: wordLengthList
                  .map(
                    (wordLength) => WordLengthButton(
                      length: wordLength.toString(),
                      onPressed: () async {
                        Provider.of<WordsProvider>(context, listen: false)
                            .setWordLength(wordLength);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
