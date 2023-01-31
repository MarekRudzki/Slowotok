import 'package:flutter/material.dart';

import 'package:slowotok/screens/home_screen/widgets/word_length_button.dart';

class WordTotalTries extends StatelessWidget {
  const WordTotalTries({
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
                WordLengthButton(
                  length: '4', //TODO pick total tries - add logic
                  onPressed: () async {},
                ),
                WordLengthButton(
                  length: '5',
                  onPressed: () async {},
                ),
                WordLengthButton(
                  length: '6',
                  onPressed: () async {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
