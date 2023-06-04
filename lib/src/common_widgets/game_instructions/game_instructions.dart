import 'package:flutter/material.dart';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:provider/provider.dart';

import '/src/common_widgets/game_instructions/widgets/instruction_page_one.dart';
import '/src/common_widgets/game_instructions/widgets/instruction_page_two.dart';
import '/src/services/providers/words_provider.dart';

class GameInstructions extends StatefulWidget {
  const GameInstructions({
    super.key,
    required this.wordsProvider,
  });

  final WordsProvider wordsProvider;

  @override
  State<GameInstructions> createState() => _GameInstructionsState();
}

class _GameInstructionsState extends State<GameInstructions> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.wordsProvider.setInstructionDialogPage(page: 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int pageIndex = context.select(
      (WordsProvider wordsProvider) => wordsProvider.getInstructionDialogPage(),
    );

    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 200,
                      padding: const EdgeInsets.symmetric(
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).appBarTheme.backgroundColor,
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
                    ExpandablePageView(
                      animationDuration: const Duration(milliseconds: 850),
                      controller: _pageController,
                      onPageChanged: (pageIndex) {
                        widget.wordsProvider
                            .setInstructionDialogPage(page: pageIndex);
                      },
                      children: [
                        const InstructionPageOne(),
                        const InstructionPageTwo(),
                      ],
                    ),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'OK',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (pageIndex == 0)
              Align(
                heightFactor: 12,
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    widget.wordsProvider.setInstructionDialogPage(page: 1);
                    _pageController.nextPage(
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
            if (pageIndex == 1)
              Align(
                heightFactor: 9,
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    widget.wordsProvider.setInstructionDialogPage(page: 0);
                    _pageController.previousPage(
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
          ],
        ),
      ),
    );
  }
}
