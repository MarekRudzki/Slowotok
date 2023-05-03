import 'package:flutter/material.dart';

import '/src/services/hive/hive_introduction_screen.dart';

class IntroductionScreenProvider with ChangeNotifier {
  final HiveIntroductionScreen _hiveIntroductionScreen =
      HiveIntroductionScreen();

  int introductionScreenPageIndex = 0;

  void changeIntroductionScreen({required int pageIndex}) {
    introductionScreenPageIndex = pageIndex;
    notifyListeners();
  }

  bool showIntroductionScreen() {
    return _hiveIntroductionScreen.getIntroductionScreenStatus();
  }

  Future<void> deactivateIntroductionScreen() async {
    await _hiveIntroductionScreen.deactivateIntroductionScreen();
  }
}
