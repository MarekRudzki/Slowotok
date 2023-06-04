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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

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

    return InkWell(
      child: Container(
        width: buildButtonWidth(
          buttonText: buttonText,
          screenWidth: screenWidth,
        ),
        height: screenHeight * 0.06,
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.006,
        ),
        child: buildContainerChild(
          buttonText: buttonText,
          context: context,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: buildButtonColor(
            buttonText: buttonText,
            context: context,
            correctLetterColor: Constants.correctLetterColor,
            initialLetterColor: Constants.initialColor,
            noLetterColor: Constants.noLetterInWordColor,
            wrongLetterColor: Constants.wrongLetterColor,
          ),
        ),
      ),
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
    );
  }
}

Widget buildContainerChild(
    {required String buttonText, required BuildContext context}) {
  if (buttonText == 'ENTER') {
    return const Icon(
      Icons.keyboard_return_rounded,
      color: Colors.white,
    );
  } else if (buttonText == 'BACKSPACE') {
    return const Icon(
      Icons.keyboard_backspace_rounded,
      color: Colors.white,
    );
  } else {
    return Center(
      child: Text(
        buttonText,
        style: TextStyle(
          color: context.watch<WordsProvider>().getLetters()[buttonText] == 0
              ? Colors.black
              : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}

double buildButtonWidth(
    {required String buttonText, required double screenWidth}) {
  final List<String> bottomRow = ['Z', 'X', 'C', 'V', 'B', 'N', 'M'];
  final List<String> middleBottomRow = [
    'A',
    'S',
    'D',
    'F',
    'G',
    'H',
    'J',
    'K',
    'L'
  ];
  if (buttonText == 'ENTER') {
    return screenWidth * 0.22;
  } else if (buttonText == 'BACKSPACE') {
    return screenWidth * 0.12;
  } else if (bottomRow.contains(buttonText)) {
    return (screenWidth - screenWidth * 0.22) * 0.125;
  } else if (middleBottomRow.contains(buttonText)) {
    return (screenWidth - screenWidth * 0.12) * 0.095;
  } else {
    return screenWidth * 0.088;
  }
}

Color buildButtonColor({
  required String buttonText,
  required BuildContext context,
  required Color correctLetterColor,
  required Color initialLetterColor,
  required Color noLetterColor,
  required Color wrongLetterColor,
}) {
  if (buttonText == 'BACKSPACE') {
    return const Color.fromARGB(255, 138, 137, 137);
  } else if (buttonText == 'ENTER') {
    return correctLetterColor;
  } else if (context.watch<WordsProvider>().getLetters()[buttonText] == 0) {
    return initialLetterColor;
  } else if (context.watch<WordsProvider>().getLetters()[buttonText] == 1) {
    return noLetterColor;
  } else if (context.watch<WordsProvider>().getLetters()[buttonText] == 2) {
    return wrongLetterColor;
  } else {
    return correctLetterColor;
  }
}
