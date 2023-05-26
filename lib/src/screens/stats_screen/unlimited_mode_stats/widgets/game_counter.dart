import 'package:flutter/material.dart';

class GameCounter extends StatelessWidget {
  const GameCounter({
    super.key,
    required this.totalGamesNumber,
  });

  final int totalGamesNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Łączna liczba rozgrywek: ',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                totalGamesNumber.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade400,
                ),
              ),
            ],
          ),
          Divider(
            color: Theme.of(context).dividerColor,
            thickness: 2,
            endIndent: 80,
            indent: 80,
          )
        ],
      ),
    );
  }
}
