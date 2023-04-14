import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';

import '/src/common_widgets/game_instructions.dart';
import '/src/services/words_provider.dart';
import 'widgets/exit_alert_dialog.dart';
import 'widgets/letters_grid.dart';
import 'widgets/keyboard.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool isPlaying = false;
  final confettiController = ConfettiController(
    duration: const Duration(seconds: 2),
  );

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WordsProvider>();
    final gameWord = provider.correctWord;
    final bool wordSolveAttempt = provider.isGameLostAtExit();

    if (provider.gameWon) {
      confettiController.play();
    }

    Future<bool> _onWillPop(BuildContext context) async {
      final bool? exitResult = await showDialog(
        context: context,
        builder: (context) => ExitAlertDialog(
          wordSolveAttempt: wordSolveAttempt,
          provider: provider,
        ),
      );
      return exitResult ?? false;
    }

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.background,
                leading: IconButton(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ExitAlertDialog(
                        wordSolveAttempt: wordSolveAttempt,
                        provider: provider,
                      ),
                    ).then(
                      (exit) => {
                        if (exit as bool)
                          {
                            Provider.of<WordsProvider>(context, listen: false)
                                .restartWord(),
                            Navigator.of(context).pop(),
                          }
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                ),
                centerTitle: true,
                title: provider.gameMode == 'wordsoftheday'
                    ? FutureBuilder(
                        future: provider.getGameStatus(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: snapshot.data!
                                  .map(
                                    (wordStatus) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7),
                                      child: Icon(
                                        wordStatus == 0
                                            ? Icons.radio_button_unchecked
                                            : wordStatus == 1
                                                ? Icons.task_alt
                                                : Icons.cancel,
                                        color: wordStatus == 0
                                            ? Colors.yellow
                                            : wordStatus == 1
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      )
                    : const SizedBox.shrink(),
                actions: [
                  IconButton(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const GameInstructions(),
                      );
                    },
                    icon: const Icon(
                      Icons.info_outline,
                    ),
                  ),
                ],
              ),
              body: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    LettersGrid(
                      wordLength: gameWord.length,
                    ),
                    const Spacer(),
                    const Keyboard(),
                    const SizedBox(height: 30)
                  ],
                ),
              ),
            ),
            ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 35,
              emissionFrequency: 0.12,
              gravity: 0.1,
              maximumSize: const Size(20, 10),
              minimumSize: const Size(15, 7.5),
            )
          ],
        ),
      ),
    );
  }
}
