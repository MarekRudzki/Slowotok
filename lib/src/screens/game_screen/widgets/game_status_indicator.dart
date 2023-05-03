import 'package:flutter/material.dart';

import '/src/services/providers/words_provider.dart';

class GameStatusIndicator extends StatelessWidget {
  const GameStatusIndicator({
    super.key,
    required this.provider,
  });

  final WordsProvider provider;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: provider.getGameStatus(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: snapshot.data!
                .map(
                  (wordStatus) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
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
    );
  }
}
