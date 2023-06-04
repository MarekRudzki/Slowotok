import 'package:flutter/material.dart';

import 'package:slide_countdown/slide_countdown.dart';
import 'package:provider/provider.dart';

import '/src/common_widgets/options_button.dart';
import '/src/screens/stats_screen/stats_screen.dart';
import '/src/services/providers/words_provider.dart';
import '/src/services/constants.dart';
import 'game_status_indicator.dart';
import 'words_of_the_day_games_summary.dart';
import 'letter_tile.dart';

class WordsOfTheDaySummaryDialog extends StatefulWidget {
  const WordsOfTheDaySummaryDialog({
    super.key,
    required this.provider,
  });

  final WordsProvider provider;

  @override
  State<WordsOfTheDaySummaryDialog> createState() =>
      _WordsOfTheDaySummaryDialogState();
}

class _WordsOfTheDaySummaryDialogState
    extends State<WordsOfTheDaySummaryDialog> {
  PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.provider.checkDialogHeight(pageIndex: 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int pageIndex = context.select(
        (WordsProvider wordsProvider) => wordsProvider.getDialogPageIndex());
    final List<String> correctWords = widget.provider.getCorrectWords();

    int calculateTime() {
      final int currentHour = DateTime.now().hour;
      final int currentMinute = DateTime.now().minute;
      final int currentSecond = DateTime.now().second;

      final int currentSecondOfDay =
          (currentHour * 60 * 60) + (currentMinute * 60) + currentSecond;
      final int secondsToNextDay = 86400 - currentSecondOfDay;

      return secondsToNextDay;
    }

    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'Twoje próby',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Container(
                    height: 300,
                    child: PageView(
                      controller: pageController,
                      onPageChanged: (index) async {
                        widget.provider.setWotdDialogPage(indexPage: index);
                        await widget.provider
                            .checkDialogHeight(pageIndex: index);
                      },
                      children: [
                        WordsOfTheDayGamesSummary(
                          provider: widget.provider,
                          correctWords: correctWords,
                          currentWordLevel: 0,
                        ),
                        WordsOfTheDayGamesSummary(
                          provider: widget.provider,
                          correctWords: correctWords,
                          currentWordLevel: 1,
                        ),
                        WordsOfTheDayGamesSummary(
                          provider: widget.provider,
                          correctWords: correctWords,
                          currentWordLevel: 2,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: UnconstrainedBox(
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                height: 25,
                                width: 38,
                                color: pageIndex == 0
                                    ? Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer
                                    : Colors.transparent,
                                duration: const Duration(milliseconds: 450),
                                curve: Curves.easeIn,
                              ),
                              AnimatedContainer(
                                height: 25,
                                width: 38,
                                color: pageIndex == 1
                                    ? Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer
                                    : Colors.transparent,
                                duration: const Duration(milliseconds: 450),
                                curve: Curves.easeIn,
                              ),
                              AnimatedContainer(
                                height: 25,
                                width: 38,
                                color: pageIndex == 2
                                    ? Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer
                                    : Colors.transparent,
                                duration: const Duration(milliseconds: 450),
                                curve: Curves.easeIn,
                              )
                            ],
                          ),
                          GameStatusIndicator(provider: widget.provider),
                        ],
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: widget.provider.getGameStatus(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return AnimatedCrossFade(
                          duration: const Duration(
                            seconds: 1,
                          ),
                          firstCurve: Curves.easeInOut,
                          secondCurve: Curves.easeInOut,
                          firstChild: snapshot.data![pageIndex] == 2
                              ? Column(
                                  children: [
                                    Text(
                                      'Poprawne hasło to:',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: correctWords[pageIndex]
                                            .split('')
                                            .map(
                                              (letter) => LetterTile(
                                                  letter: letter,
                                                  color: Constants
                                                      .correctLetterColor),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                          secondChild: const SizedBox.shrink(),
                          crossFadeState: context.select(
                                  (WordsProvider wordsProvider) =>
                                      wordsProvider.isDialogLong())
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  Text(
                    'Do następnych słówek dnia pozostało:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: SlideCountdown(
                      duration: Duration(seconds: calculateTime()),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                      ),
                      replacement: Container(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        padding: const EdgeInsets.all(6),
                        child: const Text(
                          textAlign: TextAlign.center,
                          'Nowe słówka dnia właśnie się pojawiły! Zamknij okno i zagraj',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  OptionsButton(
                    text: 'Zagraj w poprzednie dni',
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const StatsScreen(
                            showUnlimitedFirst: false,
                          ),
                        ),
                      );
                    },
                  ),
                  OptionsButton(
                    text: 'Wróć do menu',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
          if (pageIndex != 0)
            Align(
              heightFactor: 10,
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  widget.provider.setWotdDialogPage(indexPage: pageIndex - 1);
                  pageController.previousPage(
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.easeIn,
                  );
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          Positioned(
            right: 0.0,
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          if (pageIndex != 2)
            Align(
              heightFactor: 10,
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  widget.provider.setWotdDialogPage(indexPage: pageIndex + 1);
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.easeIn,
                  );
                },
                icon: Icon(
                  Icons.arrow_forward,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
