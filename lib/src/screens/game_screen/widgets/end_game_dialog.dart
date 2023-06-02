import 'package:flutter/material.dart';

import '/src/common_widgets/options_button.dart';
import '/src/screens/stats_screen/stats_screen.dart';
import '/src/screens/home_screen/home_screen.dart';
import '/src/services/providers/words_provider.dart';
import '/src/services/constants.dart';
import 'words_of_the_day_summary_dialog.dart';
import 'game_status_indicator.dart';
import 'letters_grid.dart';
import 'letter_tile.dart';

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
          Radius.circular(40),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Theme.of(context).colorScheme.background,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
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
                    wordLength: provider.getSelectedWordLength(),
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
                          children: provider
                              .getCorrectWord()
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
                if (provider.getGameMode() == 'unlimited')
                  OptionsButton(
                    text: 'Kolejne hasło',
                    onPressed: () async {
                      await provider.restartWord();
                      if (context.mounted)
                        await provider
                            .setRandomWord(
                              context: context,
                            )
                            .then(
                              (_) => Navigator.of(context).pop(),
                            );
                    },
                  )
                else
                  FutureBuilder(
                    future: provider.gameModeAvailable(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final bool gameAvailable = snapshot.data!;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GameStatusIndicator(provider: provider),
                            ),
                            if (gameAvailable)
                              OptionsButton(
                                text: 'Kolejne hasło dnia',
                                onPressed: () async {
                                  await provider.restartWord();
                                  if (context.mounted)
                                    await provider
                                        .setRandomWord(
                                          context: context,
                                        )
                                        .then(
                                          (_) => Navigator.of(context).pop(),
                                        );
                                },
                              ),
                            if (!gameAvailable &&
                                !provider.isPlayingMissedDay())
                              OptionsButton(
                                text: 'Podsumowanie',
                                onPressed: () async {
                                  await provider.restartWord();
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen(),
                                      ),
                                    );
                                    if (context.mounted)
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return WordsOfTheDaySummaryDialog(
                                            provider: provider,
                                          );
                                        },
                                      );
                                    return;
                                  }
                                },
                              )
                          ],
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                OptionsButton(
                  text: 'Zobacz statystyki',
                  onPressed: () async {
                    await provider.restartWord();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StatsScreen(
                            showUnlimitedFirst:
                                provider.getGameMode() == 'unlimited',
                          ),
                        ),
                      );
                    }
                  },
                ),
                OptionsButton(
                  text: 'Wyjdź do menu',
                  onPressed: () async {
                    await provider.restartWord();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    }
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
