import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';

import '../../common_widgets/game_instructions.dart';
import '../../services/constants.dart';
import '../../services/words_provider.dart';
import 'widgets/letters_grid.dart';
import 'widgets/keyboard.dart';

class WordleScreen extends StatefulWidget {
  const WordleScreen({
    super.key,
    required this.wordToGuess,
    required this.wordLength,
  });

  final String wordToGuess;
  final int wordLength;

  @override
  State<WordleScreen> createState() => _WordleScreenState();
}

class _WordleScreenState extends State<WordleScreen> {
  bool isPlaying = false;
  final controller = ConfettiController(
    duration: const Duration(seconds: 2),
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WordsProvider>();
    if (provider.gameWon) {
      controller.play();
    }
    AlertDialog _buildExitDialog(BuildContext context) {
      final bool gameLostAtExit = provider.gameLostAtExit();
      return AlertDialog(
        title: const Text('Na pewno?'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Chcesz wyjść i opuścić te hasło?'),
            const SizedBox(
              height: 5,
            ),
            Text(
              gameLostAtExit
                  ? 'Podjęto próbę rozwiązania hasła - gra zostanie zaliczona jako przegrana.'
                  : 'Gra nie zostanie zaliczona jako przegrana.',
              style: const TextStyle(
                color: Color.fromARGB(255, 225, 193, 51),
              ),
            )
          ],
        ),
        contentPadding: const EdgeInsets.fromLTRB(25, 15, 10, 0),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Nie'),
          ),
          TextButton(
            onPressed: () async {
              if (gameLostAtExit) {
                provider.markGameAsLost();
              }
              if (context.mounted) {
                Navigator.of(context).pop(true);
                Provider.of<WordsProvider>(context, listen: false)
                    .restartWord();
              }
            },
            child: const Text('Tak'),
          ),
        ],
      );
    }

    Future<bool> _onWillPop(BuildContext context) async {
      final bool? exitResult = await showDialog(
        context: context,
        builder: (context) => _buildExitDialog(context),
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
              appBar: AppBar(
                title: Text('Słowoku na ${widget.wordLength}'),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => _buildExitDialog(context),
                    ).then((exit) => {
                          if (exit as bool)
                            {
                              Provider.of<WordsProvider>(context, listen: false)
                                  .restartWord(),
                              Navigator.of(context).pop(),
                            }
                        });
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                ),
                actions: [
                  IconButton(
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
              body: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Constants.gradientBackgroundLighter,
                      Constants.gradientBackgroundDarker,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    LettersGrid(
                      wordLength: widget.wordLength,
                    ),
                    const Spacer(),
                    const Keyboard(),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
            ConfettiWidget(
              confettiController: controller,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 30,
              gravity: 0.15,
              emissionFrequency: 0.1,
            )
          ],
        ),
      ),
    );
  }
}
