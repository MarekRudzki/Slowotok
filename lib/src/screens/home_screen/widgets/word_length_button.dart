import 'package:flutter/material.dart';
import 'package:slowotok/src/services/constants.dart';

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
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 44,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Constants.noLetterInWordColor,
        ),
        child: Center(
          child: Text(
            length,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
