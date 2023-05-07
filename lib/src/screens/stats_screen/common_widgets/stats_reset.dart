import 'package:flutter/material.dart';

import '/src/services/providers/stats_provider.dart';

class StatsReset extends StatelessWidget {
  const StatsReset({
    super.key,
    required this.statsProvider,
  });

  final StatsProvider statsProvider;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: statsProvider.isResetButtonVisible(),
      child: IconButton(
        icon: const Icon(
          Icons.restart_alt,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.background,
                title: Text(
                  'Reset statystyk',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                content: Text(
                  'Czy na pewno chcesz zresetować swoje statystyki w tym trybie? Tej operacji nie można cofnąć.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                actions: [
                  TextButton(
                    child: const Text(
                      'Nie',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text(
                      'Tak',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                    onPressed: () async {
                      await statsProvider.resetStatistics();
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(
                              seconds: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            content: const Text(
                              'Pomyślnie zresetowano statystyki',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
