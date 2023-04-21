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

    await wordsOfTheDayBox.put('games_status', gamesStatus);
    await wordsOfTheDayBox.put('game_date', currentDate);
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

    // Game levels:
    // 0 = first level
    // 1 = second level
    // 2 = third level
    gamesStatusList[gameLevel] = isWinner ? 1 : 2;

    await wordsOfTheDayBox.put('games_status', gamesStatusList);
  }

  Future<void> addUserWords({
    required List<String> words,
    required int gameLevel,
  }) async {
    await wordsOfTheDayBox.put('user_words_$gameLevel', words);
  }

  Future<List<List<String>>> getAllUserWords() async {
    final List<String> firstLevelWords =
        await wordsOfTheDayBox.get('user_words_0') as List<String>;
    final List<String> secondLevelWords =
        await wordsOfTheDayBox.get('user_words_1') as List<String>;
    final List<String> thirdLevelWords =
        await wordsOfTheDayBox.get('user_words_2') as List<String>;

    final List<List<String>> allUserWords = [
      firstLevelWords,
      secondLevelWords,
      thirdLevelWords,
    ];

    return allUserWords;
  }

  Future<void> addCorrectWord({
    required String correctWord,
    required int gameLevel,
  }) async {
    await wordsOfTheDayBox.put('correct_word_$gameLevel', correctWord);
  }

  Future<List<String>> getCorrectWords() async {
    final String firstCorrectWord =
        await wordsOfTheDayBox.get('correct_word_0') as String;
    final String secondCorrectWord =
        await wordsOfTheDayBox.get('correct_word_1') as String;
    final String thirdCorrectWord =
        await wordsOfTheDayBox.get('correct_word_2') as String;

    return [
      firstCorrectWord,
      secondCorrectWord,
      thirdCorrectWord,
    ];
  }
}
