import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slowotok/src/services/words_provider.dart';

import '../../../common_widgets/options_button.dart';
import 'start_game_button.dart';
import 'word_length_picker.dart';
import 'word_total_tries_picker.dart';

class UnlimitedGameMode extends StatelessWidget {
  const UnlimitedGameMode({super.key});

  @override
  Widget build(BuildContext context) {
    return OptionsButton(
      text: 'Tryb nieograniczony',
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              backgroundColor: Theme.of(context).colorScheme.background,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Provider.of<WordsProvider>(context, listen: false)
                            .resetWordLengthAndTries();
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.close,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const WordLengthPicker(),
                    const SizedBox(height: 15),
                    const WordTotalTriesPicker(),
                    const SizedBox(height: 20),
                    const StartGameButton(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
