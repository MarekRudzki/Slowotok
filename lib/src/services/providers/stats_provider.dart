import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '../../screens/stats_screen/wotd_mode_stats/widgets/event_model.dart';
import '/src/services/hive/hive_statistics.dart';

class StatsProvider with ChangeNotifier {
  final HiveStatistics _hiveStatistics = HiveStatistics();

  String currentStatsType = 'unlimited';
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  bool hasAnyStatistics() {
    if (getNumberOfGames() == 0 &&
        _hiveStatistics.checkForWotdStatistics() == false) {
      return false;
    } else {
      return true;
    }
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

  // Unlimited Game Mode

  Box<dynamic> getStatsBox() {
    return _hiveStatistics.statsBox;
  }

  int getNumberOfGames() {
    return _hiveStatistics.statsBox.get('game_counter') as int;
  }

  bool isResetButtonVisible() {
    if (getNumberOfGames() == 0 || currentStatsType == 'wotd') {
      return false;
    } else {
      return true;
    }
  }

  Future<void> resetStatistics() async {
    await _hiveStatistics.setInitialStats();
    notifyListeners();
  }

  // Words Of The Day Game Mode

  bool hasWotdStatistics() {
    return _hiveStatistics.checkForWotdStatistics();
  }

  DateTime getFirstDay() {
    final stats = getWotdStatistics();
    final List<DateTime> allDates = [];

    for (final DateTime day in stats.keys) {
      allDates.add(day);
    }
    allDates.sort();
    return allDates.first;
  }

  void changeFocusedDay({required DateTime day}) {
    _focusedDay = day;
    notifyListeners();
  }

  DateTime getFocusedDay() {
    return _focusedDay;
  }

  void changeSelectedDay({required DateTime day}) {
    _selectedDay = day;
    notifyListeners();
  }

  DateTime getSelectedDay() {
    return _selectedDay;
  }

  String getSelectedDateFormatted(DateTime date) {
    final Map<int, String> dayData = {
      1: "Poniedziałek",
      2: "Wtorek",
      3: "Środa",
      4: "Czwartek",
      5: "Piątek",
      6: "Sobota",
      7: "Niedziela",
    };

    final Map<int, String> monthData = {
      1: "Styczeń",
      2: "Luty",
      3: "Marzec",
      4: "Kwiecień",
      5: "Maj",
      6: "Czerwiec",
      7: "Lipiec",
      8: "Sierpień",
      9: "Wrzesień",
      10: "Październik",
      11: "Listopad",
      12: "Grudzień",
    };

    return '${dayData[date.weekday]}, ${date.day} ${monthData[date.month]} ${date.year}';
  }

  Map<DateTime, List<Event>> getWotdStatistics() {
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

  Future<void> addWotdStatistics({required bool isWin}) async {
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

  List<bool> getSingleDayStats() {
    return _hiveStatistics.getWotdModeStatsForGivenDay(
        date: _selectedDay.toString().substring(0, 10));
  }

  // Future<void> addStatsForDay(
  //     {required List<bool> isWin, required String day}) async {
  //   final String currentDay = day;

  //   await _hiveStatistics.addWotdModeStats(
  //     date: currentDay,
  //     dayStats: isWin,
  //   );
  // } //TODO testing

  // Game Calendar

  bool isLeftChevronVisible() {
    final DateTime firstDay = getFirstDay();

    final String focusedDate = '${_focusedDay.year}-${_focusedDay.month}';
    final String firstMonth = '${firstDay.year}-${firstDay.month}';

    if (focusedDate == firstMonth) {
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
