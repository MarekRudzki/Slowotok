import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:slowotok/src/screens/home_screen/widgets/word_total_tries_button.dart';
import 'package:slowotok/src/services/words_provider.dart';

class WordTotalTriesPicker extends StatelessWidget {
  const WordTotalTriesPicker({
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
          const Center(
            child: Text(
              'Wybierz liczbę prób',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
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
                WordTotalTriesButton(
                  tries: '4',
                  onPressed: () async {
                    Provider.of<WordsProvider>(context, listen: false)
                        .setTotalTries(4);
                  },
                ),
                WordTotalTriesButton(
                  tries: '5',
                  onPressed: () async {
                    Provider.of<WordsProvider>(context, listen: false)
                        .setTotalTries(5);
                  },
                ),
                WordTotalTriesButton(
                  tries: '6',
                  onPressed: () async {
                    Provider.of<WordsProvider>(context, listen: false)
                        .setTotalTries(6);
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
