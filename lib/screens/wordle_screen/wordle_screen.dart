import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/services/words_provider.dart';
import 'widgets/letters_grid.dart';
import 'widgets/keyboard.dart';

class WordleScreen extends StatelessWidget {
  const WordleScreen({
    super.key,
    required this.wordToGuess,
    required this.wordLength,
  });

  final String wordToGuess;
  final int wordLength;

  @override
  Widget build(BuildContext context) {
    AlertDialog _buildExitDialog(BuildContext context) {
      return AlertDialog(
        title: const Text('Proszę potwierdź'),
        content: const Text('Na pewno chcesz wyjść i opuścić te hasło?'),
        backgroundColor: Theme.of(context).backgroundColor,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Nie'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              Provider.of<WordsProvider>(context, listen: false).restartWord();
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
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            title: Text('Słowoku na $wordLength'),
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
                onPressed: () {}, //TODO showDialog with instructions
                icon: const Icon(
                  Icons.info_outline,
                ),
              ),
            ],
          ),
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade700, Colors.purple.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                LettersGrid(
                  wordLength: wordLength,
                ),
                const Spacer(),
                const Keyboard(),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
