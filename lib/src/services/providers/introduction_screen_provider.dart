import 'package:flutter/material.dart';

import '/src/services/hive/hive_introduction_screen.dart';

class IntroductionScreenProvider with ChangeNotifier {
  final HiveIntroductionScreen _hiveIntroductionScreen =
      HiveIntroductionScreen();

  int _introductionScreenPageIndex = 0;
  double _iconOpacity = 0.0;
  double _firstTextOpacity = 0.0;
  double _secondTextOpacity = 0.0;
  double _thirdTextOpacity = 0.0;

  Future<void> manageOpacity() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
    _iconOpacity = 1.0;
    notifyListeners();

    await Future.delayed(
      const Duration(seconds: 1),
    );
    _firstTextOpacity = 1.0;
    notifyListeners();

    await Future.delayed(
      const Duration(milliseconds: 1200),
    );
    _secondTextOpacity = 1.0;
    notifyListeners();

    await Future.delayed(
      const Duration(seconds: 2),
    );
    _thirdTextOpacity = 1.0;
    notifyListeners();
  }

  int getPageIndex() {
    return _introductionScreenPageIndex;
  }

  double getIconOpacity() {
    return _iconOpacity;
  }

  double getFirstTextOpacity() {
    return _firstTextOpacity;
  }

  double getSecondTextOpacity() {
    return _secondTextOpacity;
  }

  double getThirdTextOpacity() {
    return _thirdTextOpacity;
  }

  void changeIntroductionScreen({required int pageIndex}) {
    _introductionScreenPageIndex = pageIndex;
    notifyListeners();
  }

  bool showIntroductionScreen() {
    return _hiveIntroductionScreen.getIntroductionScreenStatus();
  }

  Future<void> deactivateIntroductionScreen() async {
    await _hiveIntroductionScreen.deactivateIntroductionScreen();
  }
}
