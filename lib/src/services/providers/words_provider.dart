import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:adaptive_theme/adaptive_theme.dart';

import '/src/services/hive/hive_words_of_the_day.dart';
import '/src/services/providers/stats_provider.dart';
import '/src/services/hive/hive_unlimited.dart';

class WordsProvider with ChangeNotifier {
  WordsProvider({
    required this.hiveUnlimited,
    required this.hiveWordsOfTheDay,
    required this.statsProvider,
  });

  final HiveUnlimited hiveUnlimited;
  final HiveWordsOfTheDay hiveWordsOfTheDay;
  final StatsProvider statsProvider;

  /// Initial values ///

  bool _isPlayingMissedDay = false;
  String _gameMode = 'unlimited';
  int _selectedTotalTries = 0;
  int _selectedWordLength = 0;
  String _correctWord = '';
  bool _completed = false;
  bool _gameWon = false;
  int _index = 0;
  int _instructionDialogPage = 0;
  List<bool> _status = [false, false, false, false, false, false];
  List<String> _guesses = ['', '', '', '', '', ''];
  Map<String, int> _letters = {
    "Q": 0,
    "W": 0,
    "E": 0,
    "R": 0,
    "T": 0,
    "Y": 0,
    "U": 0,
    "I": 0,
    "O": 0,
    "P": 0,
    "A": 0,
    "S": 0,
    "D": 0,
    "F": 0,
    "G": 0,
    "H": 0,
    "J": 0,
    "K": 0,
    "L": 0,
    "Z": 0,
    "X": 0,
    "C": 0,
    "V": 0,
    "B": 0,
    "N": 0,
    "M": 0,
    "Ą": 0,
    "Ś": 0,
    "Ę": 0,
    "Ć": 0,
    "Ż": 0,
    "Ź": 0,
    "Ń": 0,
    "Ó": 0,
    "Ł": 0,
  };

  // Wotd - WordsOfTheDay
  int _wotdDialogPageIndex = 0;
  bool _isWotdDialogLong = false;
  DateTime _selectedDay = DateTime.now();

  // Theme
  bool _isDark = false;

  /// Setters ///

  void setMissedDayStatus({required bool playingMissedDay}) {
    _isPlayingMissedDay = playingMissedDay;
    notifyListeners();
  }

  void setGameMode({required String newGameMode}) {
    _gameMode = newGameMode;
    notifyListeners();
  }

  void setTotalTries(int tries) {
    _selectedTotalTries = tries;
    notifyListeners();
  }

  void setWordLength(int length) {
    _selectedWordLength = length;
    notifyListeners();
  }

  void resetWordLengthAndTries() {
    _selectedTotalTries = 0;
    _selectedWordLength = 0;
  }

  void setGameEndStatus({required bool isGameWon}) {
    _gameWon = isGameWon;
    notifyListeners();
  }

  Future<void> markGameAsLost() async {
    if (_gameMode == 'unlimited') {
      await hiveUnlimited.addUnlimitedGameStats(
        isWinner: false,
        wordLength: _selectedWordLength,
        totalTries: _selectedTotalTries,
      );
    } else {
      if (_isPlayingMissedDay) {
        await saveGame(isWinner: false);
      } else {
        await statsProvider.addWotdStatistics(isWin: false);
      }
    }
  }

  Future<void> setRandomWord({
    required BuildContext context,
  }) async {
    final lettersList = await DefaultAssetBundle.of(context)
        .loadString('assets/${_selectedWordLength}_letter_words.txt');

    final LineSplitter ls = const LineSplitter();
    final List<String> convertedList = ls.convert(lettersList);

    final random = Random();
    final randomWord = convertedList[random.nextInt(convertedList.length)];

    if (_gameMode == 'wordsoftheday') {
      final List<String> usedWords = hiveWordsOfTheDay.getCorrectWords();

      if (usedWords.contains(randomWord.toUpperCase())) {
        convertedList.remove(randomWord);

        final newRandomWord =
            convertedList[random.nextInt(convertedList.length - 1)];
        _correctWord = newRandomWord.toUpperCase();

        return;
      }
    }
    _correctWord = randomWord.toUpperCase();
  }

  // Wotd mode

  void playWotdMode({required DateTime date}) {
    _selectedTotalTries = 6;
    _selectedWordLength = 5;
    _selectedDay = date;
    _gameMode = 'wordsoftheday';
    notifyListeners();
  }

  void setSelectedDay({required DateTime date}) {
    _selectedDay = date;
    notifyListeners();
  }

  void setWotdDialogPage({required int indexPage}) {
    _wotdDialogPageIndex = indexPage;
    notifyListeners();
  }

  Future<void> checkDialogHeight({required int pageIndex}) async {
    final List<int> gameStatus = await getGameStatus();
    if (gameStatus[pageIndex] == 1) {
      _isWotdDialogLong = false;
    } else {
      _isWotdDialogLong = true;
    }
    notifyListeners();
  }

  Future<void> setGameStatus({
    required int gameLevel,
    required bool isWinner,
  }) async {
    await hiveWordsOfTheDay.changeGameStatus(
      gameLevel: gameLevel,
      isWinner: isWinner,
    );

    if (!_isPlayingMissedDay) {
      await hiveWordsOfTheDay.addUserWords(
        words: _guesses,
        gameLevel: gameLevel,
      );

      await hiveWordsOfTheDay.addCorrectWord(
        correctWord: _correctWord,
        gameLevel: gameLevel,
      );
    }
  }

  /// Getters ///

  bool isCompleted() {
    return _completed;
  }

  int getWordIndex() {
    return _index;
  }

  DateTime getSelectedDay() {
    return _selectedDay;
  }

  bool isPlayingMissedDay() {
    return _isPlayingMissedDay;
  }

  String getGameMode() {
    return _gameMode;
  }

  int getSelectedTries() {
    return _selectedTotalTries;
  }

  int getSelectedWordLength() {
    return _selectedWordLength;
  }

  String getCorrectWord() {
    return _correctWord;
  }

  bool isGameWon() {
    return _gameWon;
  }

  List<bool> getStatusList() {
    return _status;
  }

  List<String> getGuessesList() {
    return _guesses;
  }

  Map<String, int> getLetters() {
    return _letters;
  }

  int getDialogPageIndex() {
    return _wotdDialogPageIndex;
  }

  bool isDialogLong() {
    return _isWotdDialogLong;
  }

  bool isDark() {
    return _isDark;
  }

  bool isGameLostAtExit() {
    if (_status[0] == true) {
      return true;
    } else {
      return false;
    }
  }

  String getLetter(int index, int letterIndex) {
    return _guesses[index].length <= letterIndex
        ? ""
        : _guesses[index][letterIndex];
  }

  Future<List<int>> getGameStatus() async {
    final List<int> statusList = [];
    if (_isPlayingMissedDay) {
      final List<bool> statsForGivenDay =
          hiveWordsOfTheDay.getWotdStatsForGivenDay(
              date: _selectedDay.toString().substring(0, 10));

      statsForGivenDay.map((isWin) {
        isWin ? statusList.add(1) : statusList.add(2);
      }).toList();

      for (int i = statusList.length; i < 3; i++) {
        statusList.add(0);
      }
    } else {
      await gamePlayChecker();
      final List<int> gameStatus = hiveWordsOfTheDay.getGamesStatus();
      statusList.addAll(gameStatus);
    }
    return statusList;
  }

  Future<int> getCurrentGameLevel() async {
    final List<int> gameStatus = hiveWordsOfTheDay.getGamesStatus();

    if (gameStatus[0] == 0) {
      return 0;
    } else if (gameStatus[1] == 0) {
      return 1;
    } else if (gameStatus[2] == 0) {
      return 2;
    } else {
      return 99; // 99 stands for missed day game, should not be saved in current day stats
    }
  }

  List<List<String>> getUserWords() {
    final List<List<String>> wordsList = hiveWordsOfTheDay.getAllUserWords();
    return wordsList;
  }

  List<String> getCorrectWords() {
    final List<String> wordsList = hiveWordsOfTheDay.getCorrectWords();
    return wordsList;
  }

  Future<bool> gameModeAvailable() async {
    final List<int> gameStatus = await getGameStatus();

    if (!gameStatus.contains(0)) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> checkIfWordExists({
    required String word,
    required BuildContext context,
  }) async {
    final allWordsList =
        await DefaultAssetBundle.of(context).loadString('assets/all_words.txt');

    final LineSplitter ls = const LineSplitter();
    final List<String> allWordsConvertedList = ls.convert(allWordsList);
    if (allWordsConvertedList.contains(word)) {
      return true;
    } else {
      return false;
    }
  }

  /// Words management

  void addLetter(String letter) {
    if (_guesses[_index].length < _selectedWordLength && _completed == false) {
      _guesses[_index] += letter;
    }
    notifyListeners();
  }

  void deleteLetter() {
    if (_guesses[_index].isNotEmpty && _completed == false) {
      _guesses[_index] =
          _guesses[_index].substring(0, _guesses[_index].length - 1);
    }
    notifyListeners();
  }

  void letterController() {
    for (int i = 0; i < _selectedWordLength; i++) {
      if (_guesses[_index][i] == _correctWord[i]) {
        _letters[_guesses[_index][i]] = 3;
      } else if (_correctWord.contains(_guesses[_index][i]) &&
          _letters[_guesses[_index][i]] != 3) {
        _letters[_guesses[_index][i]] = 2;
      } else if (_correctWord.contains(_guesses[_index][i]) == false) {
        _letters[_guesses[_index][i]] = 1;
      }
    }

    notifyListeners();
  }

  Future<int> saveWord({required BuildContext context}) async {
    // word too short = status 1
    // no word in dictionary = status 2
    // game won = status 3
    // game lost = status 4

    if (_guesses[_index].length < _correctWord.length) {
      return 1;
    }

    final bool isWordCorrect = await checkIfWordExists(
      word: _guesses[_index],
      context: context,
    );

    if (!isWordCorrect) {
      return 2;
    }

    if (_guesses[_index].length == _selectedWordLength) {
      _status[_index] = true;
      if (_guesses[_index] == _correctWord) {
        if (_gameMode == 'unlimited') {
          await hiveUnlimited.addUnlimitedGameStats(
            isWinner: true,
            wordLength: _selectedWordLength,
            totalTries: _selectedTotalTries,
          );
        } else if (!_isPlayingMissedDay) {
          await statsProvider.addWotdStatistics(isWin: true);
        }

        _completed = true;
        letterController();
        notifyListeners();
        return 3;
      }

      if (_index == _selectedTotalTries - 1) {
        if (_gameMode == 'unlimited') {
          await hiveUnlimited.addUnlimitedGameStats(
            isWinner: false,
            wordLength: _selectedWordLength,
            totalTries: _selectedTotalTries,
          );
        } else if (!_isPlayingMissedDay) {
          await statsProvider.addWotdStatistics(isWin: false);
        }

        letterController();
        _completed = true;
        notifyListeners();

        return 4;
      }
      letterController();
      _index++;

      notifyListeners();
      return 0;
    }
    notifyListeners();
    return 0;
  }

  Future<void> restartWord() async {
    _gameWon = false;
    _completed = false;
    _index = 0;
    _status = [false, false, false, false, false, false];
    _guesses = ['', '', '', '', '', ''];
    _letters = {
      "Q": 0,
      "W": 0,
      "E": 0,
      "R": 0,
      "T": 0,
      "Y": 0,
      "U": 0,
      "I": 0,
      "O": 0,
      "P": 0,
      "A": 0,
      "S": 0,
      "D": 0,
      "F": 0,
      "G": 0,
      "H": 0,
      "J": 0,
      "K": 0,
      "L": 0,
      "Z": 0,
      "X": 0,
      "C": 0,
      "V": 0,
      "B": 0,
      "N": 0,
      "M": 0,
      "Ą": 0,
      "Ś": 0,
      "Ę": 0,
      "Ć": 0,
      "Ż": 0,
      "Ź": 0,
      "Ń": 0,
      "Ó": 0,
      "Ł": 0,
    };
    notifyListeners();
  }

  Future<void> saveGame({required bool isWinner}) async {
    if (_isPlayingMissedDay) {
      await statsProvider.addStatsForMissingDay(
          isWin: isWinner, date: _selectedDay.toString().substring(0, 10));
    } else {
      final int gameLevel = await getCurrentGameLevel();
      await setGameStatus(
        gameLevel: gameLevel,
        isWinner: isWinner,
      );
    }
  }

  Future<void> gamePlayChecker() async {
    final String date = _selectedDay.toString().substring(0, 10);

    final bool gamePlayedToday =
        hiveWordsOfTheDay.checkIfWotdPlayedGivenDay(date: date);

    if (!gamePlayedToday) {
      await hiveWordsOfTheDay.setInitialValues(currentDate: date);
    }
  }

  void setInstructionDialogPage({required int page}) {
    _instructionDialogPage = page;
    notifyListeners();
  }

  int getInstructionDialogPage() {
    return _instructionDialogPage;
  }

  void setTheme(AdaptiveThemeMode theme) {
    theme == AdaptiveThemeMode.dark ? _isDark = true : _isDark = false;
  }
}
