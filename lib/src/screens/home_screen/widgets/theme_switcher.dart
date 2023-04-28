import 'package:flutter/material.dart';

import 'package:adaptive_theme/adaptive_theme.dart';

import '/src/services/words_provider.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({
    super.key,
    required this.wordsProvider,
  });

  final WordsProvider wordsProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 2.0,
              color: Theme.of(context).dividerColor,
              offset: const Offset(1, 3), // shadow direction: bottom right
            )
          ],
        ),
        child: IconButton(
          onPressed: () async {
            if (wordsProvider.isDark) {
              AdaptiveTheme.of(context).setLight();
              wordsProvider.setTheme(AdaptiveThemeMode.light);
            } else {
              AdaptiveTheme.of(context).setDark();
              wordsProvider.setTheme(AdaptiveThemeMode.dark);
            }
          },
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 850),
            transitionBuilder: (child, animation) => RotationTransition(
              turns: child.key ==
                      const ValueKey(
                        'icon1',
                      )
                  ? Tween<double>(begin: 0, end: 1.5).animate(animation)
                  : Tween<double>(begin: 1.5, end: 0).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: wordsProvider.isDark
                ? Icon(
                    size: 30,
                    color: Colors.blue.shade700,
                    Icons.mode_night,
                    key: const ValueKey(
                      'icon1',
                    ),
                  )
                : const Icon(
                    size: 30,
                    color: Colors.amber,
                    Icons.sunny,
                    key: ValueKey(
                      'icon2',
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
