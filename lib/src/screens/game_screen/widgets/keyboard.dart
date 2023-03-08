import 'package:flutter/material.dart';

import 'keyboard_button.dart';

class Keyboard extends StatelessWidget {
  const Keyboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const KeyboardButton(buttonText: 'Ą'),
            const KeyboardButton(buttonText: 'Ś'),
            const KeyboardButton(buttonText: 'Ę'),
            const KeyboardButton(buttonText: 'Ć'),
            const KeyboardButton(buttonText: 'Ż'),
            const KeyboardButton(buttonText: 'Ź'),
            const KeyboardButton(buttonText: 'Ń'),
            const KeyboardButton(buttonText: 'Ó'),
            const KeyboardButton(buttonText: 'Ł'),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const KeyboardButton(buttonText: 'Q'),
            const KeyboardButton(buttonText: 'W'),
            const KeyboardButton(buttonText: 'E'),
            const KeyboardButton(buttonText: 'R'),
            const KeyboardButton(buttonText: 'T'),
            const KeyboardButton(buttonText: 'Y'),
            const KeyboardButton(buttonText: 'U'),
            const KeyboardButton(buttonText: 'I'),
            const KeyboardButton(buttonText: 'O'),
            const KeyboardButton(buttonText: 'P'),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const KeyboardButton(buttonText: 'A'),
            const KeyboardButton(buttonText: 'S'),
            const KeyboardButton(buttonText: 'D'),
            const KeyboardButton(buttonText: 'F'),
            const KeyboardButton(buttonText: 'G'),
            const KeyboardButton(buttonText: 'H'),
            const KeyboardButton(buttonText: 'J'),
            const KeyboardButton(buttonText: 'K'),
            const KeyboardButton(buttonText: 'L'),
            const KeyboardButton(buttonText: 'BACKSPACE'),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const KeyboardButton(buttonText: 'Z'),
            const KeyboardButton(buttonText: 'X'),
            const KeyboardButton(buttonText: 'C'),
            const KeyboardButton(buttonText: 'V'),
            const KeyboardButton(buttonText: 'B'),
            const KeyboardButton(buttonText: 'N'),
            const KeyboardButton(buttonText: 'M'),
            const KeyboardButton(buttonText: 'ENTER'),
          ],
        ),
      ],
    );
  }
}
