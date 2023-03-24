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
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Łączna liczba rozgrywek: ',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                statsBox.get('game_counter').toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade400,
                ),
              ),
            ],
          ),
          const Divider(
            color: Color.fromARGB(66, 224, 224, 224),
            thickness: 2,
            endIndent: 80,
            indent: 80,
          )
        ],
      ),
    );
  }
}
