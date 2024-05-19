import 'package:flutter/material.dart';

import 'keyboard_button.dart';

class Keyboard extends StatelessWidget {
  const Keyboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            KeyboardButton(buttonText: 'Ą'),
            KeyboardButton(buttonText: 'Ś'),
            KeyboardButton(buttonText: 'Ę'),
            KeyboardButton(buttonText: 'Ć'),
            KeyboardButton(buttonText: 'Ż'),
            KeyboardButton(buttonText: 'Ź'),
            KeyboardButton(buttonText: 'Ń'),
            KeyboardButton(buttonText: 'Ó'),
            KeyboardButton(buttonText: 'Ł'),
          ],
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            KeyboardButton(buttonText: 'Q'),
            KeyboardButton(buttonText: 'W'),
            KeyboardButton(buttonText: 'E'),
            KeyboardButton(buttonText: 'R'),
            KeyboardButton(buttonText: 'T'),
            KeyboardButton(buttonText: 'Y'),
            KeyboardButton(buttonText: 'U'),
            KeyboardButton(buttonText: 'I'),
            KeyboardButton(buttonText: 'O'),
            KeyboardButton(buttonText: 'P'),
          ],
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            KeyboardButton(buttonText: 'A'),
            KeyboardButton(buttonText: 'S'),
            KeyboardButton(buttonText: 'D'),
            KeyboardButton(buttonText: 'F'),
            KeyboardButton(buttonText: 'G'),
            KeyboardButton(buttonText: 'H'),
            KeyboardButton(buttonText: 'J'),
            KeyboardButton(buttonText: 'K'),
            KeyboardButton(buttonText: 'L'),
            KeyboardButton(buttonText: 'BACKSPACE'),
          ],
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            KeyboardButton(buttonText: 'Z'),
            KeyboardButton(buttonText: 'X'),
            KeyboardButton(buttonText: 'C'),
            KeyboardButton(buttonText: 'V'),
            KeyboardButton(buttonText: 'B'),
            KeyboardButton(buttonText: 'N'),
            KeyboardButton(buttonText: 'M'),
            KeyboardButton(buttonText: 'ENTER'),
          ],
        ),
      ],
    );
  }
}
