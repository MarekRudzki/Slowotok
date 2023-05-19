import 'package:hive_flutter/hive_flutter.dart';

class HiveWordsOfTheDay {
  // Initialize box
  final wordsOfTheDayBox = Hive.box('wordsOfTheDay');

  Future<void> checkWotdStatistics() async {
    final bool statsExists = wordsOfTheDayBox.containsKey('days_stats');
    if (!statsExists) {
      await setFirstDayOfStats();
    }
  }

  bool hasAnyWotdStatistics() {
    final bool statsExists = wordsOfTheDayBox.containsKey('days_stats');
    return statsExists;
  }

  Future<void> setFirstDayOfStats() async {
    final String firstDayOfCurrentMonth =
        DateTime.now().toString().substring(0, 8);
    await wordsOfTheDayBox.put(
        'first_day_of_stats', '${firstDayOfCurrentMonth}01');
  }

  String getFirstDayOfStats() {
    return wordsOfTheDayBox.get('first_day_of_stats') as String;
  }

  Future<void> addWotdModeStats({
    required String date,
    required List<bool> dayStats,
  }) async {
    final Map<String, List<bool>> statsToAdd = {date: dayStats};
    final Map<String, List<bool>> existingStats = getWotdModeStats();

    if (existingStats.isEmpty) {
      await wordsOfTheDayBox.put('days_stats', statsToAdd);
    } else {
      existingStats.addAll({date: dayStats});
      await wordsOfTheDayBox.put('days_stats', existingStats);
    }
  }

  Map<String, List<bool>> getWotdModeStats() {
    if (!wordsOfTheDayBox.containsKey('days_stats')) {
      return {};
    } else {
      final stats = wordsOfTheDayBox.get('days_stats') as Map;

      final Map<String, List<bool>> convertedStatistics = {};
      stats.forEach(
        (date, dayStats) {
          convertedStatistics.addAll({date.toString(): dayStats as List<bool>});
        },
      );

      return convertedStatistics;
    }
  }

  List<bool> getWotdModeStatsForGivenDay({required String date}) {
    final List<bool> singleDayStats = [];
    final stats = wordsOfTheDayBox.get('days_stats') as Map;

    stats.entries.map((allStats) {
      if (date == allStats.key as String) {
        singleDayStats.addAll(allStats.value as List<bool>);
      }
    }).toList();

    return singleDayStats;
  }

  // Game status type:
  // 0 = initial
  // 1 = won,
  // 2 = lost

  Future<bool> checkIfModePlayedGivenDay({required String date}) async {
    final isDateSaved = wordsOfTheDayBox.containsKey('game_date');
    if (!isDateSaved) {
      return false;
    } else {
      final String savedDate = (wordsOfTheDayBox.get('game_date')) as String;

      if (savedDate != date) {
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
    final List<String> newList = [];
    for (final String word in words) {
      if (word.length != 5 && word.isNotEmpty) {
        final buffer = StringBuffer();
        final int missingLetters = 5 - word.length;
        for (int i = 0; i < missingLetters; i++) {
          buffer.write(' ');
        }
        newList.add(word + buffer.toString());
      } else {
        newList.add(word);
      }
    }
    await wordsOfTheDayBox.put('user_words_$gameLevel', newList);
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
    if (!wordsOfTheDayBox.containsKey('correct_word_0')) {
      return [];
    } else if (!wordsOfTheDayBox.containsKey('correct_word_1')) {
      final String firstCorrectWord =
          await wordsOfTheDayBox.get('correct_word_0') as String;
      return [firstCorrectWord];
    } else if (!wordsOfTheDayBox.containsKey('correct_word_2')) {
      final String firstCorrectWord =
          await wordsOfTheDayBox.get('correct_word_0') as String;
      final String secondCorrectWord =
          await wordsOfTheDayBox.get('correct_word_1') as String;
      return [firstCorrectWord, secondCorrectWord];
    } else {
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
}
