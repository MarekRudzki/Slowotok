import 'package:hive_flutter/hive_flutter.dart';

class HiveStatistics {
  // Initialize box
  final statsBox = Hive.box('statsBox');

  /// Check if user already have statistics in local memory
  /// If not set initial values
  Future<void> checkForStatistics() async {
    final bool statsExists = statsBox.containsKey('game_counter');
    if (!statsExists) {
      await setInitialStats();
    }
  }

  Future<void> setInitialStats() async {
    await statsBox.put('game_counter', 0);
    await statsBox.put('game_won', 0);

    await statsBox.put('4_letter_game', 0);
    await statsBox.put('5_letter_game', 0);
    await statsBox.put('6_letter_game', 0);
    await statsBox.put('7_letter_game', 0);

    await statsBox.put('4_tries_game', 0);
    await statsBox.put('5_tries_game', 0);
    await statsBox.put('6_tries_game', 0);

    // Detailed game statistics (4_4 means game with 4 words and 4 tries)
    await statsBox.put('4_4_game', 0);
    await statsBox.put('4_4_won', 0);
    await statsBox.put('4_5_game', 0);
    await statsBox.put('4_5_won', 0);
    await statsBox.put('4_6_game', 0);
    await statsBox.put('4_6_won', 0);

    await statsBox.put('5_4_game', 0);
    await statsBox.put('5_4_won', 0);
    await statsBox.put('5_5_game', 0);
    await statsBox.put('5_5_won', 0);
    await statsBox.put('5_6_game', 0);
    await statsBox.put('5_6_won', 0);

    await statsBox.put('6_4_game', 0);
    await statsBox.put('6_4_won', 0);
    await statsBox.put('6_5_game', 0);
    await statsBox.put('6_5_won', 0);
    await statsBox.put('6_6_game', 0);
    await statsBox.put('6_6_won', 0);

    await statsBox.put('7_4_game', 0);
    await statsBox.put('7_4_won', 0);
    await statsBox.put('7_5_game', 0);
    await statsBox.put('7_5_won', 0);
    await statsBox.put('7_6_game', 0);
    await statsBox.put('7_6_won', 0);
  }

  /// Add game statistics on game finish
  Future<void> addGameStatistics({
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
    final int gamesPlayed = statsBox.get('game_counter') as int;
    final int newGameValue = gamesPlayed + 1;
    await statsBox.put('game_counter', newGameValue);
  }

  Future<void> addGameWon() async {
    final int gamesWon = statsBox.get('game_won') as int;
    final int newGamesValue = gamesWon + 1;
    await statsBox.put('game_won', newGamesValue);
  }

  // Total tries bar chart
  Future<void> addSelectedTries({
    required int tries,
  }) async {
    final int gamesTriesCounter = statsBox.get('${tries}_tries_game') as int;
    final int newCounterValue = gamesTriesCounter + 1;
    await statsBox.put('${tries}_tries_game', newCounterValue);
  }

  // Word length bar chart
  Future<void> addSelectedLength({
    required int length,
  }) async {
    final int gamesLengthCounter = statsBox.get('${length}_letter_game') as int;
    final int newLengthValue = gamesLengthCounter + 1;
    await statsBox.put('${length}_letter_game', newLengthValue);
  }

  // Win percentage bar chart
  Future<void> addWinPercentageStats({
    required bool isWinner,
    required int wordLength,
    required int totalTries,
  }) async {
    final int currentGameValue =
        statsBox.get('${wordLength}_${totalTries}_game') as int;
    final int newGameValue = currentGameValue + 1;
    await statsBox.put('${wordLength}_${totalTries}_game', newGameValue);

    if (isWinner) {
      final int currentWinValue =
          statsBox.get('${wordLength}_${totalTries}_won') as int;
      final int newWinValue = currentWinValue + 1;
      await statsBox.put('${wordLength}_${totalTries}_won', newWinValue);
    }
  }
}