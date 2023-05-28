import 'package:flutter/material.dart';

import '/src/common_widgets/options_button.dart';

class InstructionPageTwo extends StatelessWidget {
  const InstructionPageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Center(
                child: Text(
                  'Masz do wyboru dwa tryby gry',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
              endIndent: 30,
              indent: 30,
            ),
            OptionsButton(
              text: 'Tryb nieograniczony',
              onPressed: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Center(
                child: Text(
                  'W tym trybie możesz grać ile chcesz! Możesz również wybrać długość słowa i liczbę prób.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            OptionsButton(
              text: 'Słówka dnia',
              onPressed: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Center(
                child: Text(
                  'Klasyczny tryb, którego celem jest odgadnięcie 5 literowego hasła. Spróbuj zgadnąć wszystkie dzienne hasła!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
