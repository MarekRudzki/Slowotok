import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '/src/services/hive/hive_statistics.dart';

class StatsProvider with ChangeNotifier {
  final HiveStatistics _hiveStatistics = HiveStatistics();

  String currentStatsType = 'unlimited';

  Box<dynamic> getStatsBox() {
    return _hiveStatistics.statsBox;
  }

  String getDisplayedStatsType() {
    return currentStatsType;
  }

  void setDisplayedStatsType({
    required String statsType,
  }) {
    currentStatsType = statsType;
    notifyListeners();
  }

  int getNumberOfGames() {
    return _hiveStatistics.statsBox.get('game_counter') as int;
  }

  Future<void> resetStatistics() async {
    await _hiveStatistics.setInitialStats();
    notifyListeners();
  }
}
