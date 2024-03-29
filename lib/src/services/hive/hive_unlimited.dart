import 'package:hive_flutter/hive_flutter.dart';

class HiveUnlimited {
  /// Initialize box
  final _unlimitedStatsBox = Hive.box('unlimitedStatsBox');

  /// Check if user already have statistics in local memory
  /// If not set initial values
  Future<void> checkUnlimitedStats() async {
    final bool statsExists = _unlimitedStatsBox.containsKey('game_counter');
    if (!statsExists) {
      await setInitialStats();
    }
  }

  Future<void> setInitialStats() async {
    await _unlimitedStatsBox.put('game_counter', 0);
    await _unlimitedStatsBox.put('game_won', 0);

    final List<int> gameLength = [4, 5, 6, 7];
    final List<int> gameTries = [4, 5, 6];

    Future.wait(gameLength.map((length) async {
      await _unlimitedStatsBox.put('${length}_letter_game', 0);
    }));

    Future.wait(gameTries.map((tries) async {
      await _unlimitedStatsBox.put('${tries}_tries_game', 0);
    }));

    Future.wait(gameLength.map((length) async {
      Future.wait(gameTries.map(
        (tries) async {
          await _unlimitedStatsBox.put('${length}_${tries}_game', 0);
          await _unlimitedStatsBox.put('${length}_${tries}_won', 0);
        },
      ));
    }));
  }

  /// Add game statistics on game finish
  Future<void> addUnlimitedGameStats({
    required bool isWinner,
    required int wordLength,
    required int totalTries,
  }) async {
    await addGameCount();
    if (isWinner) {
      await addGameWon();
    }
    await addSelectedLength(length: wordLength);
    await addSelectedTries(tries: totalTries);

    await addWinPercentageStats(
      isWinner: isWinner,
      wordLength: wordLength,
      totalTries: totalTries,
    );
  }

  /// Individual game statistics

  // Game counter & pie chart
  Future<void> addGameCount() async {
    final int gamesPlayed = _unlimitedStatsBox.get('game_counter') as int;
    final int newGameValue = gamesPlayed + 1;
    await _unlimitedStatsBox.put('game_counter', newGameValue);
  }

  Future<void> addGameWon() async {
    final int gamesWon = _unlimitedStatsBox.get('game_won') as int;
    final int newGamesValue = gamesWon + 1;
    await _unlimitedStatsBox.put('game_won', newGamesValue);
  }

  // Total tries bar chart
  Future<void> addSelectedTries({
    required int tries,
  }) async {
    final int gamesTriesCounter =
        _unlimitedStatsBox.get('${tries}_tries_game') as int;
    final int newCounterValue = gamesTriesCounter + 1;
    await _unlimitedStatsBox.put('${tries}_tries_game', newCounterValue);
  }

  // Word length bar chart
  Future<void> addSelectedLength({
    required int length,
  }) async {
    final int gamesLengthCounter =
        _unlimitedStatsBox.get('${length}_letter_game') as int;
    final int newLengthValue = gamesLengthCounter + 1;
    await _unlimitedStatsBox.put('${length}_letter_game', newLengthValue);
  }

  // Win percentage bar chart
  Future<void> addWinPercentageStats({
    required bool isWinner,
    required int wordLength,
    required int totalTries,
  }) async {
    final int currentGameValue =
        _unlimitedStatsBox.get('${wordLength}_${totalTries}_game') as int;
    final int newGameValue = currentGameValue + 1;
    await _unlimitedStatsBox.put(
        '${wordLength}_${totalTries}_game', newGameValue);

    if (isWinner) {
      final int currentWinValue =
          _unlimitedStatsBox.get('${wordLength}_${totalTries}_won') as int;
      final int newWinValue = currentWinValue + 1;
      await _unlimitedStatsBox.put(
          '${wordLength}_${totalTries}_won', newWinValue);
    }
  }

  /// Get statistics

  int getSingleStat({required String statType}) {
    return _unlimitedStatsBox.get(statType) as int;
  }
}
