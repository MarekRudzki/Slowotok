import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/src/common_widgets/options_button.dart';
import '/src/services/providers/words_provider.dart';
import 'word_total_tries_picker.dart';
import 'word_length_picker.dart';
import 'start_game_button.dart';

class UnlimitedGameMode extends StatelessWidget {
  const UnlimitedGameMode({super.key});

  @override
  Widget build(BuildContext context) {
    return OptionsButton(
      text: 'Tryb nieograniczony',
      onPressed: () {
        Provider.of<WordsProvider>(context, listen: false)
            .resetWordLengthAndTries();

        showDialog(
          context: context,
          builder: (context) {
            return ScaffoldMessenger(
              child: Builder(
                builder: (context) => Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Dialog(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.background,
                    child: Stack(
                      children: [
                        Positioned(
                          right: 0.0,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.close,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const WordLengthPicker(),
                              const SizedBox(height: 15),
                              const WordTotalTriesPicker(),
                              const SizedBox(height: 20),
                              const StartGameButton(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
