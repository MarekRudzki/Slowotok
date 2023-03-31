import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../services/words_provider.dart';
import '../../../services/constants.dart';
import 'end_game_alert_dialog.dart';

class KeyboardButton extends StatelessWidget {
  const KeyboardButton({
    super.key,
    required this.buttonText,
  });

  final String buttonText;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WordsProvider>(context, listen: false);

    Future<void> showEndDialogWithDelay({required bool isWinner}) async {
      await Future.delayed(
        const Duration(seconds: 2),
      );
      if (context.mounted) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => EndGameAlertDialog(
            provider: provider,
            isWinner: isWinner,
          ),
        );
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: buttonText == 'BACKSPACE'
            ? const Color.fromARGB(255, 138, 137, 137)
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
            final int status = await provider.saveWord(context: context);
            if (status == 3) {
              await showEndDialogWithDelay(isWinner: true);
            } else if (status == 4) {
              await showEndDialogWithDelay(isWinner: false);
            } else if (status == 1 || status == 2) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red.shade400,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    margin: const EdgeInsets.only(
                      bottom: 250,
                      right: 80,
                      left: 80,
                    ),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(
                      milliseconds: 1100,
                    ),
                    content: Text(
                      status == 1 ? 'Niekompletne słowo' : 'Brak słowa w bazie',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              }
            }
          } else if (buttonText == "BACKSPACE") {
            provider.deleteLetter();
          } else {
            provider.addLetter(
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
