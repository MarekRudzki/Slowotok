import 'package:flutter/material.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '/src/services/hive_introduction_screen.dart';
import 'screens/game_guide_1.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final HiveIntroductionScreen _hiveIntroductionScreen =
      HiveIntroductionScreen();
  final PageController _controller = PageController();
  int pageIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(
          children: [
            PageView(
              onPageChanged: (index) {
                setState(() {
                  pageIndex = index;
                });
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
                      GestureDetector(
                        child: Text(
                          'Poprzedni',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: pageIndex == 0
                                  ? Theme.of(context).colorScheme.background
                                  : Colors.black),
                        ),
                        onTap: () {
                          _controller.previousPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeIn,
                          );
                        },
                      ),
                      SmoothPageIndicator(
                        controller: _controller,
                        effect: const WormEffect(
                          activeDotColor: Colors.green,
                        ),
                        count: 3,
                      ),
                      if (pageIndex == 2)
                        GestureDetector(
                          child: const Text(
                            'Rozumiem!',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () async {
                            await _hiveIntroductionScreen
                                .deactivateIntroductionScreen();
                            if (context.mounted) Navigator.of(context).pop();
                          },
                        )
                      else
                        GestureDetector(
                          child: const Text(
                            'Następny',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeIn,
                            );
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      //_controller.jumpToPage(2);
                      //TODO this is temporray
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Pomiń',
                      style: TextStyle(
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
    );
  }
}
