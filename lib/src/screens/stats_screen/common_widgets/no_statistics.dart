import 'dart:ui';

import 'package:flutter/material.dart';

class NoStatistics extends StatelessWidget {
  const NoStatistics({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double remainingHeight = MediaQuery.of(context).size.height -
        MediaQueryData.fromWindow(window).padding.top -
        AppBar().preferredSize.height;

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: remainingHeight * 0.28),
          Text(
            'Brak statystyk!',
            style: TextStyle(
              fontSize: 17,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: remainingHeight * 0.10),
          Text(
            'Trochę tutaj pusto 😕',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Zagraj w tym trybie, aby wyświetlić statystyki.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 25),
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
