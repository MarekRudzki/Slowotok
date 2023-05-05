import 'package:flutter/material.dart';

class NoStatistics extends StatelessWidget {
  const NoStatistics({
    super.key,
    required this.hasAnyStats,
  });

  final bool hasAnyStats;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Brak statystyk',
            style: TextStyle(
              fontSize: 17,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            hasAnyStats
                ? 'Nie rozegrałeś jeszcze żadnej gry w tym trybie!'
                : 'Nie rozegrałeś jeszcze żadnej gry!', //TODO zmienic na bezosobową formę
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            child: const Text(
              'Spróbuj teraz!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
