import 'package:hive_flutter/hive_flutter.dart';

class HiveWordsOfTheDay {
  /// Initialize box
  final _wordsOfTheDayStatsBox = Hive.box('wordsOfTheDay');

  /// Check if user already have statistics in local memory
  /// If not set initial values
  Future<void> checkWotdStatistics() async {
    final bool statsExists = _wordsOfTheDayStatsBox.containsKey('days_stats');
    if (!statsExists) {
      await setFirstDayOfStats();
    }
  }

  Future<void> setFirstDayOfStats() async {
    final String firstDayOfCurrentMonth =
        DateTime.now().toString().substring(0, 8);
    await _wordsOfTheDayStatsBox.put(
        'first_day_of_stats', '${firstDayOfCurrentMonth}01');
  }

  Future<void> setInitialValues({required String currentDate}) async {
    final List<int> gamesStatus = [0, 0, 0];

    await _wordsOfTheDayStatsBox.put('games_status', gamesStatus);
    await _wordsOfTheDayStatsBox.put('game_date', currentDate);
  }

  /// Add statistics

  Future<void> addWotdStats({
    required String date,
    required List<bool> dayStats,
  }) async {
    final Map<String, List<bool>> statsToAdd = {date: dayStats};
    final Map<String, List<bool>> existingStats = getWotdStats();

    if (existingStats.isEmpty) {
      await _wordsOfTheDayStatsBox.put('days_stats', statsToAdd);
    } else {
      existingStats.addAll({date: dayStats});
      await _wordsOfTheDayStatsBox.put('days_stats', existingStats);
    }
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
    await _wordsOfTheDayStatsBox.put('user_words_$gameLevel', newList);
  }

  Future<void> addCorrectWord({
    required String correctWord,
    required int gameLevel,
  }) async {
    await _wordsOfTheDayStatsBox.put('correct_word_$gameLevel', correctWord);
  }

  Future<void> changeGameStatus({
    required int gameLevel,
    required bool isWinner,
  }) async {
    final gamesStatusList =
        await _wordsOfTheDayStatsBox.get('games_status') as List<int>;

    // Game levels:
    // 0 = first level
    // 1 = second level
    // 2 = third level
    // 99 = missed day played
    if (gameLevel != 99) {
      gamesStatusList[gameLevel] = isWinner ? 1 : 2;
    }

    await _wordsOfTheDayStatsBox.put('games_status', gamesStatusList);
  }

  /// Get statistics

  bool hasAnyWotdStatistics() {
    final bool statsExists = _wordsOfTheDayStatsBox.containsKey('days_stats');
    return statsExists;
  }

  String getFirstDayOfStats() {
    return _wordsOfTheDayStatsBox.get('first_day_of_stats') as String;
  }

  Map<String, List<bool>> getWotdStats() {
    if (!_wordsOfTheDayStatsBox.containsKey('days_stats')) {
      return {};
    } else {
      final stats = _wordsOfTheDayStatsBox.get('days_stats') as Map;

      final Map<String, List<bool>> convertedStatistics = {};
      stats.forEach(
        (date, dayStats) {
          convertedStatistics.addAll({date.toString(): dayStats as List<bool>});
        },
      );

      return convertedStatistics;
    }
  }

  List<bool> getWotdStatsForGivenDay({required String date}) {
    final List<bool> singleDayStats = [];
    final stats = _wordsOfTheDayStatsBox.get('days_stats') as Map;

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

  bool checkIfWotdPlayedGivenDay({required String date}) {
    final isDateSaved = _wordsOfTheDayStatsBox.containsKey('game_date');
    if (!isDateSaved) {
      return false;
    } else {
      final String savedDate =
          (_wordsOfTheDayStatsBox.get('game_date')) as String;

      if (savedDate != date) {
        return false;
      }
    }
    return true;
  }

  List<int> getGamesStatus() {
    return _wordsOfTheDayStatsBox.get('games_status') as List<int>;
  }

  List<List<String>> getAllUserWords() {
    final List<String> firstLevelWords =
        _wordsOfTheDayStatsBox.get('user_words_0') as List<String>;
    final List<String> secondLevelWords =
        _wordsOfTheDayStatsBox.get('user_words_1') as List<String>;
    final List<String> thirdLevelWords =
        _wordsOfTheDayStatsBox.get('user_words_2') as List<String>;

    final List<List<String>> allUserWords = [
      firstLevelWords,
      secondLevelWords,
      thirdLevelWords,
    ];

    return allUserWords;
  }

  List<String> getCorrectWords() {
    if (!_wordsOfTheDayStatsBox.containsKey('correct_word_0')) {
      return [];
    } else if (!_wordsOfTheDayStatsBox.containsKey('correct_word_1')) {
      final String firstCorrectWord =
          _wordsOfTheDayStatsBox.get('correct_word_0') as String;
      return [firstCorrectWord];
    } else if (!_wordsOfTheDayStatsBox.containsKey('correct_word_2')) {
      final String firstCorrectWord =
          _wordsOfTheDayStatsBox.get('correct_word_0') as String;
      final String secondCorrectWord =
          _wordsOfTheDayStatsBox.get('correct_word_1') as String;
      return [firstCorrectWord, secondCorrectWord];
    } else {
      final String firstCorrectWord =
          _wordsOfTheDayStatsBox.get('correct_word_0') as String;
      final String secondCorrectWord =
          _wordsOfTheDayStatsBox.get('correct_word_1') as String;
      final String thirdCorrectWord =
          _wordsOfTheDayStatsBox.get('correct_word_2') as String;

      return [
        firstCorrectWord,
        secondCorrectWord,
        thirdCorrectWord,
      ];
    }
  }

  /// Statistics reset

  Future<void> resetStatsForGivenDay({required String date}) async {
    final String today = DateTime.now().toString().substring(0, 10);

    final stats = _wordsOfTheDayStatsBox.get('days_stats') as Map;
    stats.removeWhere((key, value) => key as String == date);
    await _wordsOfTheDayStatsBox.put('days_stats', stats);

    if (date == today) {
      await _wordsOfTheDayStatsBox.delete('correct_word_0');
      await _wordsOfTheDayStatsBox.delete('correct_word_1');
      await _wordsOfTheDayStatsBox.delete('correct_word_2');
      await _wordsOfTheDayStatsBox.delete('user_words_0');
      await _wordsOfTheDayStatsBox.delete('user_words_1');
      await _wordsOfTheDayStatsBox.delete('user_words_2');
      await _wordsOfTheDayStatsBox.delete('game_date');
    }
  }
}
