import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GameCounter extends StatelessWidget {
  const GameCounter({
    super.key,
    required this.statsBox,
  });

  final Box<dynamic> statsBox;

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
                statsBox.get('game_counter').toString(),
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
