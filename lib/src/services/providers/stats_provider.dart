import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '../../screens/stats_screen/wotd_mode_stats/widgets/event_model.dart';
import '/src/services/hive/hive_statistics.dart';

class StatsProvider with ChangeNotifier {
  final HiveStatistics _hiveStatistics = HiveStatistics();

  String _currentStatsType = 'unlimited';
  DateTime _focusedDay = DateTime.now();

  Box<dynamic> getStatsBox() {
    return _hiveStatistics.statsBox;
  }

  bool hasAnyStatistics() {
    if (getNumberOfGames() == 0 &&
        _hiveStatistics.checkForWotdStatistics() == false) {
      return false;
    } else {
      return true;
    }
  }

  bool hasWotdStatistics() {
    return _hiveStatistics.checkForWotdStatistics();
  }

  String getDisplayedStatsType() {
    return _currentStatsType;
  }

  void setDisplayedStatsType({
    required String statsType,
  }) {
    _currentStatsType = statsType;
    notifyListeners();
  }

  int getNumberOfGames() {
    return _hiveStatistics.statsBox.get('game_counter') as int;
  }

  Map<DateTime, List<Event>> getWotdStats() {
    final Map<String, List<bool>> stats = _hiveStatistics.getWotdModeStats();
    final Map<DateTime, List<Event>> formattedStats = {};
    stats.forEach(
      (date, statsList) {
        final DateTime formattedCurrentDay = DateTime.parse(date);
        formattedStats.addAll(
          {
            formattedCurrentDay: statsList
                .map(
                  (isWin) => Event(isWin: isWin),
                )
                .toList()
          },
        );
      },
    );
    return formattedStats;
  }

  Future<void> addWotdStats({required bool isWin}) async {
    final String currentDay = DateTime.now().toString().substring(0, 10);
    final Map<String, List<bool>> stats = _hiveStatistics.getWotdModeStats();
    if (!stats.containsKey(currentDay)) {
      await _hiveStatistics.addWotdModeStats(
        date: currentDay,
        dayStats: [isWin],
      );
    } else {
      stats.forEach(
        (date, statsList) async {
          if (date == currentDay) {
            statsList.add(isWin);
            await _hiveStatistics.addWotdModeStats(
              date: currentDay,
              dayStats: statsList,
            );
          }
        },
      );
    }
  }

  // Stats reset

  Future<void> resetStatistics() async {
    await _hiveStatistics.setInitialStats();
    notifyListeners();
  }

  bool isResetButtonVisible() {
    if (getNumberOfGames() == 0 || _currentStatsType == 'wotd') {
      return false;
    } else {
      return true;
    }
  }

  // Game Calendar

  DateTime getFirstDay() {
    final allDates = getWotdStats();

    return allDates.keys.first;
  }

  DateTime getFocusedDay() {
    return _focusedDay;
  }

  void changeFocusedDay({required DateTime day}) {
    _focusedDay = day;
    notifyListeners();
  }

  bool isLeftChevronVisible() {
    final String focusedDate = '${_focusedDay.year}-${_focusedDay.month}';
    final String currentDate = '2023-1';

    if (focusedDate == currentDate) {
      return false;
    } else {
      return true;
    }
  }

  bool isRightChevronVisible() {
    final String focusedDate = '${_focusedDay.year}-${_focusedDay.month}';
    final String currentDate = '${DateTime.now().year}-${DateTime.now().month}';

    if (focusedDate == currentDate) {
      return false;
    } else {
      return true;
    }
  }
}
