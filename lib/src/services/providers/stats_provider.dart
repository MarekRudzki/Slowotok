import 'package:flutter/material.dart';

import '/src/screens/stats_screen/wotd_mode_stats/widgets/event_model.dart';
import '/src/services/hive/hive_words_of_the_day.dart';
import '/src/services/hive/hive_unlimited.dart';

class StatsProvider with ChangeNotifier {
  final HiveUnlimited _hiveUnlimited = HiveUnlimited();
  final HiveWordsOfTheDay _hiveWordsOfTheDay = HiveWordsOfTheDay();

  String _currentStatsType = 'unlimited';
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  Future<void> checkForStatistics() async {
    await _hiveUnlimited.checkUnlimitedStats();
    await _hiveWordsOfTheDay.checkWotdStatistics();
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

  // Unlimited Game Mode

  int getNumberOfGames() {
    return _hiveUnlimited.getSingleStat(statType: 'game_counter');
  }

  int getGamesWon() {
    return _hiveUnlimited.getSingleStat(statType: 'game_won');
  }

  int getGamesForGivenLengthAndTries({
    required int wordLength,
    required int totalTries,
  }) {
    return _hiveUnlimited.getSingleStat(
        statType: '${wordLength}_${totalTries}_game');
  }

  int getWonGamesForGivenLengthAndTries({
    required int wordLength,
    required int totalTries,
  }) {
    return _hiveUnlimited.getSingleStat(
        statType: '${wordLength}_${totalTries}_won');
  }

  int getGamesNumberForGivenLength({required int wordLength}) {
    return _hiveUnlimited.getSingleStat(statType: '${wordLength}_letter_game');
  }

  int getGamesNumberForGivenTries({required int totalTries}) {
    return _hiveUnlimited.getSingleStat(statType: '${totalTries}_letter_game');
  }

  bool isResetButtonVisible() {
    if (getNumberOfGames() == 0 || _currentStatsType == 'wotd') {
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
    final Map<String, List<bool>> stats = _hiveWordsOfTheDay.getWotdStats();
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
    final Map<String, List<bool>> stats = _hiveWordsOfTheDay.getWotdStats();
    if (!stats.containsKey(currentDay)) {
      await _hiveWordsOfTheDay.addWotdStats(
        date: currentDay,
        dayStats: [isWin],
      );
    } else {
      stats.forEach(
        (date, statsList) async {
          if (date == currentDay) {
            statsList.add(isWin);
            await _hiveWordsOfTheDay.addWotdStats(
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
        _hiveWordsOfTheDay.getWotdStatsForGivenDay(
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
    int winNumber = 0;
    int loseNumber = 0;
    for (int i = 0; i < givenDayStats.length; i++) {
      if (givenDayStats[i] == 'win') {
        winNumber++;
      } else if (givenDayStats[i] == 'lose') {
        loseNumber++;
      }
    }

    if (winNumber == 3) {
      return 'perfect';
    } else if (winNumber == 0 && loseNumber == 0) {
      return 'unstarted';
    } else if (givenDayStats.contains('no_data')) {
      return 'unfinished';
    } else if (winNumber == 1) {
      return 'not-bad';
    } else if (loseNumber == 3) {
      return 'try-again';
    } else {
      return 'almost-perfect';
    }
  }

  Future<void> resetDayStats() async {
    await _hiveWordsOfTheDay.resetStatsForGivenDay(
        date: _selectedDay.toString().substring(0, 10));
  }

  Future<void> addStatsForMissingDay(
      {required bool isWin, required String date}) async {
    final List<bool> statsForMissingDay =
        _hiveWordsOfTheDay.getWotdStatsForGivenDay(date: date);

    statsForMissingDay.add(isWin);
    await _hiveWordsOfTheDay.addWotdStats(
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
