import 'package:flutter/material.dart';
import 'package:slowotok/src/screens/game_screen/widgets/letters_grid.dart';
import 'package:slowotok/src/screens/stats_screen/stats_screen.dart';
import 'package:slowotok/src/services/constants.dart';

import '../../../services/words_provider.dart';
import '../../home_screen/home_screen.dart';
import '../../../common_widgets/options_button.dart';

class EndGameDialog extends StatelessWidget {
  const EndGameDialog({
    super.key,
    required this.provider,
    required this.isWinner,
  });

  final WordsProvider provider;
  final bool isWinner;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(25),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            40,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Theme.of(context).colorScheme.background,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  isWinner ? 'Gratulacje!' : 'Próbuj dalej!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Transform.scale(
                  scale: 0.85,
                  child: LettersGrid(
                    wordLength: provider.selectedWordLength,
                  ),
                ),
                Text(
                  isWinner
                      ? 'Udało Ci się odgadnąć hasło!'
                      : 'Niestety, tym razem się nie udało.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                if (!isWinner)
                  Column(
                    children: [
                      Text(
                        'Poszukiwane hasło to:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: provider.correctWord
                              .split('')
                              .map(
                                (letter) => LetterTile(
                                  letter: letter,
                                  color: Constants.correctLetterColor,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                OptionsButton(
                  text: 'Kolejne hasło',
                  onPressed: () async {
                    provider.restartWord();
                    await provider
                        .getRandomWord(
                          context: context,
                        )
                        .then(
                          (_) => Navigator.of(context).pop(),
                        );
                  },
                ),
                OptionsButton(
                  text: 'Zobacz statystyki',
                  onPressed: () {
                    provider.restartWord();
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const StatsScreen(),
                      ),
                    );
                  },
                ),
                OptionsButton(
                  text: 'Wyjdź do menu',
                  onPressed: () {
                    provider.restartWord();
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LetterTile extends StatelessWidget {
  const LetterTile({
    super.key,
    required this.letter,
    required this.color,
  });

  final String letter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        width: 32,
        height: 41,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(
            13,
          ),
        ),
        child: Center(
          child: Text(
            letter,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
