import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/src/services/providers/words_provider.dart';
import '/src/services/constants.dart';
import 'end_game_dialog.dart';

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
      provider.setGameEndStatus(isGameWon: isWinner);

      if (provider.getGameMode() == 'wordsoftheday') {
        await provider.saveGame(isWinner: isWinner);
      }

      await Future.delayed(
        const Duration(seconds: 2),
      ).then(
        (_) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child: EndGameDialog(
                provider: provider,
                isWinner: isWinner,
              ),
            ),
          );
        },
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: buttonText == 'BACKSPACE'
            ? const Color.fromARGB(255, 138, 137, 137)
            : buttonText == 'ENTER'
                ? Constants.correctLetterColor
                : context.watch<WordsProvider>().getLetters()[buttonText] == 0
                    ? Constants.initialColor
                    : context.watch<WordsProvider>().getLetters()[buttonText] ==
                            1
                        ? Constants.noLetterInWordColor
                        : context
                                    .watch<WordsProvider>()
                                    .getLetters()[buttonText] ==
                                2
                            ? Constants.wrongLetterColor
                            : Constants.correctLetterColor,
      ),
      child: InkWell(
        onTap: () async {
          if (buttonText == "ENTER" && !provider.isGameWon()) {
            final int status = await provider.saveWord(context: context);
            if (status == 3) {
              await showEndDialogWithDelay(isWinner: true);
            } else if (status == 4) {
              await showEndDialogWithDelay(isWinner: false);
            } else if (status == 1 || status == 2) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      status == 1 ? 'Niekompletne słowo' : 'Brak słowa w bazie',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    backgroundColor: Colors.red.shade400,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    duration: const Duration(milliseconds: 1300),
                    behavior: SnackBarBehavior.floating,
                    dismissDirection: DismissDirection.none,
                    margin: const EdgeInsets.only(
                      bottom: 250,
                      right: 80,
                      left: 80,
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
                  horizontal: 30,
                )
              : const EdgeInsets.all(10),
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
                                    .getLetters()[buttonText] ==
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
