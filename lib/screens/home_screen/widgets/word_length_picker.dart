import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:slowotok/screens/home_screen/widgets/word_length_button.dart';
import 'package:slowotok/wordly_screen/wordly_screen.dart';

class WordLengthPicker extends StatelessWidget {
  const WordLengthPicker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Future<String> getRandomWord({required String wordLength}) async {
      final lettersList = await DefaultAssetBundle.of(context)
          .loadString('assets/${wordLength}_letter_words.txt');

      final LineSplitter ls = const LineSplitter();
      final List<String> convertedList = ls.convert(lettersList);

      final random = Random();
      final randomWord = convertedList[random.nextInt(convertedList.length)];

      return randomWord;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Container(
        padding: const EdgeInsets.all(
          15,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.green,
            width: 5,
          ),
        ),
        child: Column(
          children: [
            const Center(
              child: Text(
                'Wybierz długość słowa',
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WordLengthButton(
                    length: '4',
                    onPressed: () async {
                      await getRandomWord(wordLength: '4').then(
                        (value) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  WordlyScreen(wordToGuess: value),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  WordLengthButton(
                    length: '5',
                    onPressed: () async {
                      await getRandomWord(wordLength: '5').then(
                        (value) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  WordlyScreen(wordToGuess: value),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  WordLengthButton(
                    length: '6',
                    onPressed: () {},
                  ),
                  WordLengthButton(
                    length: '7',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
