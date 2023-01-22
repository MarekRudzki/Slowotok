import 'package:flutter/material.dart';

import 'package:slowotok/screens/home_screen/widgets/word_length_picker.dart';

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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade700, Colors.purple.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: Placeholder(
                      //TODO add app icon
                      fallbackHeight: MediaQuery.of(context).size.height * 0.25,
                      fallbackWidth: double.infinity,
                      color: Colors.red,
                    ),
                  ),
                ),
                const WordLengthPicker()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
