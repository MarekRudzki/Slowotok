import 'package:hive_flutter/hive_flutter.dart';

class HiveStatistics {
  final statsBox = Hive.box('statsBox');

  /// Check if user already have stats in local memory
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

    //Detailed game statistics (4_4 means game with 4 words and 4 tries)
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

  /// Add game statistics on game won/lost

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
    await addDetailedStats(
      isWinner: isWinner,
      wordLength: wordLength,
      totalTries: totalTries,
    );
  }

  /// Individual game statistics

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

  Future<void> addSelectedTries({
    required int tries,
  }) async {
    if (tries == 4) {
      final int fourTries = statsBox.get('4_tries_game') as int;
      final int newTriesValue = fourTries + 1;
      await statsBox.put('4_tries_game', newTriesValue);
    } else if (tries == 5) {
      final int fiveTries = statsBox.get('5_tries_game') as int;
      final int newTriesValue = fiveTries + 1;
      await statsBox.put('5_tries_game', newTriesValue);
    } else {
      final int sixTries = statsBox.get('6_tries_game') as int;
      final int newTriesValue = sixTries + 1;
      await statsBox.put('6_tries_game', newTriesValue);
    }
  }

  Future<void> addSelectedLength({
    required int length,
  }) async {
    if (length == 4) {
      final int fourLength = statsBox.get('4_letter_game') as int;
      final int newLengthValue = fourLength + 1;
      await statsBox.put('4_letter_game', newLengthValue);
    } else if (length == 5) {
      final int fiveLength = statsBox.get('5_letter_game') as int;
      final int newLengthValue = fiveLength + 1;
      await statsBox.put('5_letter_game', newLengthValue);
    } else if (length == 6) {
      final int sixLength = statsBox.get('6_letter_game') as int;
      final int newLengthValue = sixLength + 1;
      await statsBox.put('6_letter_game', newLengthValue);
    } else {
      final int sevenLength = statsBox.get('7_letter_game') as int;
      final int newLengthValue = sevenLength + 1;
      await statsBox.put('7_letter_game', newLengthValue);
    }
  }

  Future<void> addDetailedStats({
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
