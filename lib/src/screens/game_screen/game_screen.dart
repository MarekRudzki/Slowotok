import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';

import '/src/common_widgets/game_instructions/game_instructions.dart';
import '/src/services/providers/words_provider.dart';
import 'widgets/game_status_indicator.dart';
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
    final gameWord = provider.getCorrectWord();
    final bool wordSolveAttempt = provider.isGameLostAtExit();

    if (provider.isGameWon()) {
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
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                centerTitle: true,
                title: provider.getGameMode() == 'wordsoftheday'
                    ? GameStatusIndicator(provider: provider)
                    : const SizedBox.shrink(),
                actions: [
                  IconButton(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => GameInstructions(
                          wordsProvider: provider,
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
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
                    const SizedBox(height: 15)
                  ],
                ),
              ),
            ),
            ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 30,
              emissionFrequency: 0.12,
              maximumSize: const Size(20, 10),
              minimumSize: const Size(15, 7.5),
            )
          ],
        ),
      ),
    );
  }
}
