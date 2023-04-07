import 'package:flutter/material.dart';

import '/src/services/constants.dart';

class GameInstructions extends StatelessWidget {
  const GameInstructions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.background,
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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Jak grać?',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Twoim zadaniem jest odgadnąć hasło w określonej liczbie prób.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Po wpisaniu słowa zatwierdź go przyciskiem ',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
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
                    TextSpan(
                      text:
                          ', a kolor liter zmieni się, aby pokazać Ci, jak blisko jesteś odgadnięcia hasła.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(
                color: Colors.grey,
                thickness: 1,
                endIndent: 30,
                indent: 30,
              ),
              Text(
                'Przykłady',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset(
                'assets/no_letter_in_word.png',
                scale: 1.6,
              ),
              Text(
                'Żadna z liter nie występuje w haśle.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 5),
              Image.asset(
                'assets/letter_incorrect_place.png',
                scale: 1.6,
              ),
              Text(
                'Litera A występuje w haśle (raz lub więcej), jednak nie na podanych miejscach.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 5),
              Image.asset(
                'assets/letter_correct_place.png',
                scale: 1.6,
              ),
              Text(
                'Litera A jest w odpowiednim miejscu.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
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
