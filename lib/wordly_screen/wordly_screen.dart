import 'package:flutter/material.dart';

class WordlyScreen extends StatelessWidget {
  const WordlyScreen({
    super.key,
    required this.wordToGuess,
  });

  final String wordToGuess;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade700, Colors.purple.shade900],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Text(
              wordToGuess,
            ),
          ),
        ),
      ),
    );
  }
}
