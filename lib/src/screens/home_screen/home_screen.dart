import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slowotok/src/screens/home_screen/widgets/word_total_tries.dart';
import 'package:slowotok/src/services/constants.dart';

import '../../common_widgets/game_instructions.dart';
import 'widgets/word_length_picker.dart';
import 'widgets/menu_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<bool> _onWillPop(BuildContext context) async {
    final bool? exitResult = await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
    return exitResult ?? false;
  }

  AlertDialog _buildExitDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Proszę potwierdź'),
      content: const Text('Na pewno chcesz wyjść z aplikacji?'),
      backgroundColor: Theme.of(context).backgroundColor,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Nie'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Tak'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Constants.gradientBackgroundLighter,
                  Constants.gradientBackgroundDarker,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Material(
                    color: Colors.transparent,
                    elevation: 25,
                    child: Center(
                      child: Image.asset(
                        'assets/icon.png',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    padding: const EdgeInsets.all(
                      15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.green,
                        width: 5,
                      ),
                    ),
                    child: Column(
                      children: [
                        const WordLengthPicker(),
                        const SizedBox(height: 15),
                        const WordTotalTries(),
                        const SizedBox(height: 20),
                        MenuButton(
                          text: 'Graj',
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                ),
                MenuButton(
                  text: 'Jak grać?',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const GameInstructions(),
                    );
                  },
                ),
                MenuButton(
                  text: 'Wyjdź z aplikacji',
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
