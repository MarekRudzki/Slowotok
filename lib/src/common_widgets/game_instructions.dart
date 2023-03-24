import 'package:flutter/material.dart';

import '../services/constants.dart';

class GameInstructions extends StatelessWidget {
  const GameInstructions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Constants.gradientBackgroundLighter,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Twoim zadaniem jest odgadnąć hasło w określonej liczbie prób.',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 14),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Po wpisaniu słowa zatwierdź go przyciskiem ',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    WidgetSpan(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Constants.correctLetterColor,
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                        ),
                        child: const Icon(
                          Icons.keyboard_return_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const TextSpan(
                      text: '.',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Po każdej próbie użyte litery zmienią kolor aby pokazać Ci jak blisko jesteś odgadnięcia hasła.',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 10),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              const SizedBox(height: 10),
              const Text(
                'Przykłady',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Image.asset(
                'assets/no_letter_in_word.png',
                alignment: Alignment.centerLeft,
                scale: 1.2,
              ),
              const Text('Żadna z liter nie występuje w haśle.'),
              const SizedBox(height: 14),
              Image.asset(
                'assets/letter_incorrect_place.png',
                alignment: Alignment.centerLeft,
                scale: 1.2,
              ),
              const Text(
                  'Litera A występuje w haśle (raz lub więcej), jednak nie na podanym miejscu'),
              const SizedBox(height: 14),
              Image.asset(
                'assets/letter_correct_place.png',
                alignment: Alignment.centerLeft,
                scale: 1.2,
              ),
              const Text('Litera A jest w odpowiednim miejscu.'),
              const SizedBox(height: 14),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Constants.correctLetterColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
