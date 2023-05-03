import 'package:flutter/material.dart';

import '/src/services/hive/hive_introduction_screen.dart';

class IntroductionScreenProvider with ChangeNotifier {
  final HiveIntroductionScreen _hiveIntroductionScreen =
      HiveIntroductionScreen();

  int introductionScreenPageIndex = 0;
  double iconOpacity = 0.0;
  double firstTextOpacity = 0.0;
  double secondTextOpacity = 0.0;
  double thirdTextOpacity = 0.0;

  Future<void> manageOpacity() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
    iconOpacity = 1.0;
    notifyListeners();

    await Future.delayed(
      const Duration(seconds: 1),
    );
    firstTextOpacity = 1.0;
    notifyListeners();

    await Future.delayed(
      const Duration(seconds: 2),
    );
    secondTextOpacity = 1.0;
    notifyListeners();

    await Future.delayed(
      const Duration(seconds: 2),
    );
    thirdTextOpacity = 1.0;
    notifyListeners();
  }

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
