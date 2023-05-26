import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/src/services/providers/introduction_screen_provider.dart';

class GameGuide1 extends StatelessWidget {
  const GameGuide1({
    super.key,
    required this.introductionScreenProvider,
  });

  final IntroductionScreenProvider introductionScreenProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: introductionScreenProvider.manageOpacity(),
          builder: (context, snapshot) {
            return const SizedBox.shrink();
          },
        ),
        AnimatedOpacity(
          opacity: context.select(
            (IntroductionScreenProvider introductionScreenProvider) =>
                introductionScreenProvider.getIconOpacity(),
          ),
          duration: const Duration(milliseconds: 1500),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 35,
            ),
            child: Material(
              color: Colors.transparent,
              elevation: 25,
              child: Center(
                child: Image.asset('assets/icon.png'),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 35, 15, 15),
          child: Column(
            children: [
              AnimatedOpacity(
                opacity: context.select(
                  (IntroductionScreenProvider introductionScreenProvider) =>
                      introductionScreenProvider.getFirstTextOpacity(),
                ),
                duration: const Duration(milliseconds: 2500),
                child: const Text(
                  'Witaj!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: AnimatedOpacity(
                  opacity: context.select(
                    (IntroductionScreenProvider introductionScreenProvider) =>
                        introductionScreenProvider.getSecondTextOpacity(),
                  ),
                  duration: const Duration(milliseconds: 2500),
                  child: const Text(
                    'Oto krótki przewodnik po głównych funkcjach aplikacji.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: context.select(
                  (IntroductionScreenProvider introductionScreenProvider) =>
                      introductionScreenProvider.getThirdTextOpacity(),
                ),
                duration: const Duration(milliseconds: 2500),
                child: const Text(
                  'Jeśli chcesz, możesz go zamknąć w każdej chwili przyciskiem na dole ekranu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
