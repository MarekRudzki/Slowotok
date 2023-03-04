import 'package:hive_flutter/hive_flutter.dart';

class HiveStatistics {
  final statsBox = Hive.box('statsBox');

  // Overall games played

  Future<void> addGameStatistics({
    required bool isWinner,
    required int wordLength,
    required int totalTries,
  }) async {
    await addGameCount();
    if (isWinner) {
      await addGameWon();
    }
  }

//TODO ustawic na starcie wszystkie staty na 0
  Future<void> addGameCount() async {
    final bool statsExists = statsBox.containsKey('game_counter');

    if (statsExists) {
      final int gamesPlayed = statsBox.get('game_counter') as int;
      final int newGameValue = gamesPlayed + 1;
      await statsBox.put('game_counter', newGameValue);
    } else {
      await statsBox.put('game_counter', 1);
    }
  }

  Future<void> addGameWon() async {
    final bool statsExists = statsBox.containsKey('games_won');

    if (statsExists) {
      final int gamesWon = statsBox.get('games_won') as int;
      final int newGamesValue = gamesWon + 1;
      await statsBox.put('games_won', newGamesValue);
    } else {
      await statsBox.put('games_won', 1);
    }
  }
}
