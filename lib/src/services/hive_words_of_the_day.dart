import 'package:hive_flutter/hive_flutter.dart';

class HiveWordsOfTheDay {
  // Initialize box
  final wordsOfTheDayBox = Hive.box('wordsOfTheDay');

  // Game status type:
  // 0 = initial
  // 1 = won,
  // 2 = lost

  Future<bool> checkIfModePlayedToday({required String currentDate}) async {
    final isDateSaved = wordsOfTheDayBox.containsKey('game_date');
    if (!isDateSaved) {
      return false;
    } else {
      final String savedDate = (wordsOfTheDayBox.get('game_date')) as String;
      if (savedDate != currentDate) {
        return false;
      }
    }
    return true;
  }

  Future<void> setInitialValues({required String currentDate}) async {
    final List<int> gamesStatus = [0, 0, 0];

    wordsOfTheDayBox.put('games_status', gamesStatus);
    wordsOfTheDayBox.put('game_date', currentDate);
  }

  Future<List<int>> getGamesStatus() async {
    return await wordsOfTheDayBox.get('games_status') as List<int>;
  }

  Future<void> changeGameStatus({
    required int gameLevel,
    required bool isWinner,
  }) async {
    final gamesStatusList =
        await wordsOfTheDayBox.get('games_status') as List<int>;

    gamesStatusList[gameLevel] = isWinner ? 1 : 2;

    wordsOfTheDayBox.put('games_status', gamesStatusList);
  }
}
