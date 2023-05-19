import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:slowotok/src/services/hive/hive_words_of_the_day.dart';

import '../../screens/stats_screen/wotd_mode_stats/widgets/event_model.dart';
import '../hive/hive_unlimited.dart';

class StatsProvider with ChangeNotifier {
  final HiveUnlimited _hiveUnlimited = HiveUnlimited();
  final HiveWordsOfTheDay _hiveWordsOfTheDay = HiveWordsOfTheDay();

  String currentStatsType = 'unlimited';
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  Future<void> checkForStatistics() async {
    await _hiveUnlimited.checkUnlimitedStatistics();
    await _hiveWordsOfTheDay.checkWotdStatistics();
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
    return _hiveUnlimited.statsBox;
  }

  int getNumberOfGames() {
    return _hiveUnlimited.statsBox.get('game_counter') as int;
  }

  bool isResetButtonVisible() {
    if (getNumberOfGames() == 0 || currentStatsType == 'wotd') {
      return false;
    } else {
      return true;
    }
  }

  Future<void> resetStatistics() async {
    await _hiveUnlimited.setInitialStats();
    notifyListeners();
  }

  // Words Of The Day Game Mode

  bool hasWotdStatistics() {
    return _hiveWordsOfTheDay.hasAnyWotdStatistics();
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

  DateTime getFirstDayOfStats() {
    final String firstDayOfStats = _hiveWordsOfTheDay.getFirstDayOfStats();
    return DateTime.parse(firstDayOfStats);
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
      1: "Stycznia",
      2: "Lutego",
      3: "Marca",
      4: "Kwietnia",
      5: "Maja",
      6: "Czerwca",
      7: "Lipca",
      8: "Sierpnia",
      9: "Września",
      10: "Października",
      11: "Listopada",
      12: "Grudnia",
    };

    return '${dayData[date.weekday]}, ${date.day} ${monthData[date.month]} ${date.year}';
  }

  Map<DateTime, List<Event>> getWotdStatistics() {
    final Map<String, List<bool>> stats = _hiveWordsOfTheDay.getWotdModeStats();
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
    final Map<String, List<bool>> stats = _hiveWordsOfTheDay.getWotdModeStats();
    if (!stats.containsKey(currentDay)) {
      await _hiveWordsOfTheDay.addWotdModeStats(
        date: currentDay,
        dayStats: [isWin],
      );
    } else {
      stats.forEach(
        (date, statsList) async {
          if (date == currentDay) {
            statsList.add(isWin);
            await _hiveWordsOfTheDay.addWotdModeStats(
              date: currentDay,
              dayStats: statsList,
            );
          }
        },
      );
    }
  }

  List<String> getSingleDayStats() {
    final List<String> singleDayStats = [];
    final List<bool> statsForGivenDay =
        _hiveWordsOfTheDay.getWotdModeStatsForGivenDay(
            date: _selectedDay.toString().substring(0, 10));

    statsForGivenDay.map((isWin) {
      isWin ? singleDayStats.add('win') : singleDayStats.add('lose');
    }).toList();

    for (int i = singleDayStats.length; i < 3; i++) {
      singleDayStats.add('no_data');
    }
    return singleDayStats;
  }

  String getDayPerformance() {
    final List<String> givenDayStats = getSingleDayStats();
    if (givenDayStats[0] == 'win' &&
        givenDayStats[1] == 'win' &&
        givenDayStats[2] == 'win') {
      return 'perfect';
    } else if (givenDayStats[0] == 'no_data' &&
        givenDayStats[1] == 'no_data' &&
        givenDayStats[2] == 'no_data') {
      return 'unstarted';
    } else if (givenDayStats.contains('no_data')) {
      return 'unfinished';
    } else {
      return 'not-perfect';
    }
  }

  Future<void> addStatsForMissingDay(
      {required bool isWin, required String date}) async {
    final List<bool> statsForMissingDay =
        _hiveWordsOfTheDay.getWotdModeStatsForGivenDay(date: date);

    statsForMissingDay.add(isWin);
    await _hiveWordsOfTheDay.addWotdModeStats(
      date: date,
      dayStats: statsForMissingDay,
    );
  }

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
