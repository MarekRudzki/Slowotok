import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:slowotok/screens/home_screen/widgets/word_length_button.dart';
import 'package:slowotok/services/words_provider.dart';
import 'package:slowotok/screens/wordle_screen/wordle_screen.dart';

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
                      Provider.of<WordsProvider>(context, listen: false)
                          .setWordLength(4);
                      await Provider.of<WordsProvider>(context, listen: false)
                          .getRandomWord(
                        context: context,
                      )
                          .then(
                        (value) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => WordleScreen(
                                wordToGuess: value,
                                wordLength: 4,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  WordLengthButton(
                    length: '5',
                    onPressed: () async {
                      Provider.of<WordsProvider>(context, listen: false)
                          .setWordLength(5);
                      await Provider.of<WordsProvider>(context, listen: false)
                          .getRandomWord(
                        context: context,
                      )
                          .then(
                        (value) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => WordleScreen(
                                wordToGuess: value,
                                wordLength: 5,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  WordLengthButton(
                    length: '6',
                    onPressed: () async {
                      Provider.of<WordsProvider>(context, listen: false)
                          .setWordLength(6);
                      await Provider.of<WordsProvider>(context, listen: false)
                          .getRandomWord(
                        context: context,
                      )
                          .then(
                        (value) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => WordleScreen(
                                wordToGuess: value,
                                wordLength: 6,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  WordLengthButton(
                    length: '7',
                    onPressed: () async {
                      Provider.of<WordsProvider>(context, listen: false)
                          .setWordLength(7);
                      await Provider.of<WordsProvider>(context, listen: false)
                          .getRandomWord(
                        context: context,
                      )
                          .then(
                        (value) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => WordleScreen(
                                wordToGuess: value,
                                wordLength: 7,
                              ),
                            ),
                          );
                        },
                      );
                    },
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
