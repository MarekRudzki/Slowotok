import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/src/services/words_provider.dart';
import 'word_total_tries_button.dart';

class WordTotalTriesPicker extends StatelessWidget {
  const WordTotalTriesPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final List<int> triesList = [4, 5, 6];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Center(
            child: Text(
              'Wybierz liczbę prób',
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: triesList
                  .map(
                    (tries) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: WordTotalTriesButton(
                        tries: tries.toString(),
                        onPressed: () async {
                          Provider.of<WordsProvider>(context, listen: false)
                              .setTotalTries(tries);
                        },
                      ),
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
