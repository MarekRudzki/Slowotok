import 'package:flutter/material.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';

import '/src/screens/home_screen/home_screen.dart';
import '/src/services/providers/introduction_screen_provider.dart';
import 'widgets/game_guide_1.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int currentPage = context.select(
        (IntroductionScreenProvider introductionScreenProvider) =>
            introductionScreenProvider.introductionScreenPageIndex);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Consumer<IntroductionScreenProvider>(
          builder: (context, wordsProvider, _) => Stack(
            children: [
              PageView(
                onPageChanged: (index) {
                  wordsProvider.changeIntroductionScreen(pageIndex: index);
                },
                controller: _controller,
                children: [
                  const GameGuide1(),
                  Image.asset('assets/game_guide_1.png'),
                  Image.asset('assets/game_guide_2.png'),
                ],
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (currentPage == 0)
                          const SizedBox(width: 106)
                        else
                          OutlinedButton(
                            onPressed: () {
                              _controller.previousPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeIn,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                width: 2.0,
                                color: Colors.green,
                              ),
                            ),
                            child: const Text(
                              'Poprzedni',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        SmoothPageIndicator(
                          controller: _controller,
                          effect: const WormEffect(
                            activeDotColor: Colors.green,
                          ),
                          count: 3,
                        ),
                        if (currentPage == 2)
                          const SizedBox(width: 101)
                        else
                          OutlinedButton(
                            onPressed: () {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeIn,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                width: 2.0,
                                color: Colors.green,
                              ),
                            ),
                            child: const Text(
                              'Następny',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        await wordsProvider.deactivateIntroductionScreen();
                        if (context.mounted)
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                      },
                      child: Text(
                        currentPage == 2 ? 'Zamknij' : 'Pomiń',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
