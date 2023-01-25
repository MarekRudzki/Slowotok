import 'package:flutter/material.dart';

class WordLengthButton extends StatelessWidget {
  const WordLengthButton({
    super.key,
    required this.length,
    required this.onPressed,
  });

  final String length;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: const ButtonStyle().copyWith(
        backgroundColor: MaterialStateProperty.all(Colors.green),
      ),
      onPressed: onPressed,
      child: Text(
        length,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
