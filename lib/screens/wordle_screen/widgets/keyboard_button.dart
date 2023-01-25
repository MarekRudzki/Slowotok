import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../services/words_provider.dart';
import '../../../services/constants.dart';
import '../../home_screen/home_screen.dart';

class KeyboardButton extends StatelessWidget {
  const KeyboardButton({
    super.key,
    required this.buttonText,
  });

  final String buttonText;

  @override
  Widget build(BuildContext context) {
    AlertDialog showEndGameAlertDialog({
      required bool isWinner,
    }) {
      return AlertDialog(
        title: isWinner
            ? const Text(
                'Gratulacje!',
                style: TextStyle(
                  color: Colors.green,
                ),
              )
            : const Text(
                'Próbuj dalej!',
                style: TextStyle(
                  color: Colors.yellow,
                ),
              ),
        content: isWinner
            ? const Text('Udało Ci się odgadnąć słowo')
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Niestety tym razem się nie udało.'),
                  const Text('Poszukiwane hasło to:'),
                  Text(
                    Provider.of<WordsProvider>(context).correctWord,
                    style: const TextStyle(
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<WordsProvider>(context, listen: false).restartWord();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
            child: const Text('Wyjdź do menu'),
          ),
          TextButton(
            onPressed: () async {
              Provider.of<WordsProvider>(context, listen: false).restartWord();
              await Provider.of<WordsProvider>(context, listen: false)
                  .getRandomWord(
                wordLength: '5', //TODO adjust this to other words length
                context: context,
              );

              Navigator.of(context).pop();
            },
            child: const Text('Jeszcze raz!'),
          ),
        ],
      );
    }

    Future<void> showEndDialogWithDelay({required bool isWinner}) async {
      await Future.delayed(
        const Duration(milliseconds: 1300),
      );
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => showEndGameAlertDialog(isWinner: isWinner));
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: buttonText == 'BACKSPACE'
            ? const Color.fromARGB(255, 162, 162, 162)
            : buttonText == 'ENTER'
                ? Constants.correctLetterColor
                : context.watch<WordsProvider>().letters[buttonText] == 0
                    ? Constants.initialColor
                    : context.watch<WordsProvider>().letters[buttonText] == 1
                        ? Constants.noLetterInWordColor
                        : context.watch<WordsProvider>().letters[buttonText] ==
                                2
                            ? Constants.wrongLetterColor
                            : Constants.correctLetterColor,
      ),
      child: InkWell(
        onTap: () async {
          if (buttonText == "ENTER") {
            final int status =
                await Provider.of<WordsProvider>(context, listen: false)
                    .saveWord();
            if (status == 1) {
              await showEndDialogWithDelay(isWinner: true);
            } else if (status == 3) {
              await showEndDialogWithDelay(isWinner: false);
            }
          } else if (buttonText == "BACKSPACE") {
            Provider.of<WordsProvider>(context, listen: false).deleteLetter();
          } else {
            Provider.of<WordsProvider>(context, listen: false).addLetter(
              buttonText,
            );
          }
        },
        child: Padding(
          padding: buttonText == 'ENTER'
              ? const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                )
              : const EdgeInsets.all(8.0),
          child: buttonText == 'BACKSPACE'
              ? const Icon(
                  Icons.keyboard_backspace_rounded,
                  color: Colors.white,
                )
              : buttonText == 'ENTER'
                  ? const Icon(
                      Icons.keyboard_return_rounded,
                      color: Colors.white,
                    )
                  : Text(
                      buttonText,
                      style: TextStyle(
                        color: context
                                    .watch<WordsProvider>()
                                    .letters[buttonText] ==
                                0
                            ? Colors.black
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
        ),
      ),
    );
  }
}
