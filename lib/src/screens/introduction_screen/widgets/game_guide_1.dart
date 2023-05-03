import 'package:flutter/material.dart';

class GameGuide1 extends StatefulWidget {
  const GameGuide1({super.key});

  @override
  State<GameGuide1> createState() => _GameGuide1State();
}

class _GameGuide1State extends State<GameGuide1> {
  double _opacity = 1.0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 1500),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Material(
              color: Colors.transparent,
              elevation: 25,
              child: Center(
                child: Image.asset('assets/icon.png'),
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _opacity = _opacity == 1.0 ? 0.0 : 1.0;
            });
          },
          child: const Text('Toggle Opacity'),
        ),
      ],
    );
  }
}


// Padding(
        //   padding: const EdgeInsets.only(top: 35),
        //   child: AnimatedTextKit(
        //     animatedTexts: [
        //       TypewriterAnimatedText(
        //         'Witaj w aplikacji',
        //         textStyle: const TextStyle(
        //           fontSize: 20,
        //           fontWeight: FontWeight.w600,
        //         ),
        //         speed: const Duration(
        //           milliseconds: 90,
        //         ),
        //         cursor: '.',
        //       ),
        //     ],
        //     isRepeatingAnimation: false,
        //   ),
        // ),