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
              const Center(
                child: Text(
                  'Jak grać?',
                  style: TextStyle(
                    fontSize: 20,
                    color: Constants.correctLetterColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Twoim zadaniem jest odgadnąć hasło w określonej liczbie prób.',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Po wpisaniu słowa zatwierdź go przyciskiem ',
                      style: TextStyle(
                        fontSize: 15,
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
                          size: 15,
                        ),
                      ),
                    ),
                    const TextSpan(
                      text: '.',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Po każdej próbie użyte litery zmienią kolor, aby pokazać Ci, jak blisko jesteś odgadnięcia hasła.',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
                endIndent: 30,
                indent: 30,
              ),
              const Text(
                'Przykłady',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset(
                'assets/no_letter_in_word.png',
                scale: 1.6,
              ),
              const Text(
                'Żadna z liter nie występuje w haśle.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Image.asset(
                'assets/letter_incorrect_place.png',
                scale: 1.6,
              ),
              const Text(
                'Litera A występuje w haśle (raz lub więcej), jednak nie na podanych miejscach.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Image.asset(
                'assets/letter_correct_place.png',
                scale: 1.6,
              ),
              const Text(
                'Litera A jest w odpowiednim miejscu.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
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
