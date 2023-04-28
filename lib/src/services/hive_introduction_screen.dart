import 'package:hive_flutter/hive_flutter.dart';

class HiveIntroductionScreen {
  final introductionScreenHive = Hive.box('introduction_screen');

  Future<void> deactivateIntroductionScreen() async {
    await introductionScreenHive.put('introduction_screen_status', false);
  }

  bool getIntroductionScreenStatus() {
    if (introductionScreenHive.containsKey('introduction_screen_status')) {
      return false;
    } else {
      return true;
    }
  }
}
