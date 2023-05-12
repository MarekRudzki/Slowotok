import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:slowotok/src/services/providers/stats_provider.dart';

import '/src/services/hive/hive_words_of_the_day.dart';
import '/src/services/hive/hive_statistics.dart';

class WordsProvider with ChangeNotifier {
  final HiveStatistics _hiveStatistics = HiveStatistics();
  final HiveWordsOfTheDay _hiveWordsOfTheDay = HiveWordsOfTheDay();
  final StatsProvider _statsProvider = StatsProvider();

  //Initial values
  bool completed = false;
  bool gameWon = false;
  bool isDark = false;
  bool unlimitedDialogError = false;
  String gameMode = 'unlimited';
  int wotdDialogPageIndex = 0; // wotd - WordsOfTheDay mode
  String correctWord = '';
  int selectedTotalTries = 0;
  int selectedWordLength = 0;
  int index = 0;
  List<bool> status = [false, false, false, false, false, false];
  List<String> guesses = ["", "", "", "", "", ""];
  Map<String, int> letters = {
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

  bool isGameLostAtExit() {
    if (status[0] == true) {
      return true;
    } else {
      return false;
    }
  }

  void changeWotdDialogPage({required int indexPage}) {
    wotdDialogPageIndex = indexPage;
    notifyListeners();
  }

  void setGameEndStatus({required bool isGameWon}) {
    gameWon = isGameWon;
    notifyListeners();
  }

  Future<void> markGameAsLost() async {
    if (gameMode == 'unlimited') {
      await _hiveStatistics.addUnlimitedGameStatistics(
        isWinner: false,
        wordLength: selectedWordLength,
        totalTries: selectedTotalTries,
      );
    } else {
      await _statsProvider.addWotdStatistics(isWin: false);
    }
  }

  void setWordLength(int length) {
    selectedWordLength = length;
    notifyListeners();
  }

  void setTotalTries(int tries) {
    selectedTotalTries = tries;
    notifyListeners();
  }

  void resetWordLengthAndTries() {
    selectedTotalTries = 0;
    selectedWordLength = 0;
  }

  Future<void> setRandomWord({
    required BuildContext context,
  }) async {
    final lettersList = await DefaultAssetBundle.of(context)
        .loadString('assets/${selectedWordLength}_letter_words.txt');

    final LineSplitter ls = const LineSplitter();
    final List<String> convertedList = ls.convert(lettersList);

    final random = Random();
    final randomWord = convertedList[random.nextInt(convertedList.length)];

    if (gameMode == 'wordsoftheday') {
      final List<String> usedWords = await _hiveWordsOfTheDay.getCorrectWords();

      if (usedWords.contains(randomWord.toUpperCase())) {
        convertedList.remove(randomWord);

        final newRandomWord =
            convertedList[random.nextInt(convertedList.length - 1)];
        correctWord = newRandomWord.toUpperCase();

        return;
      }
    }
    correctWord = randomWord.toUpperCase();
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

  String getLetter(int index, int letterIndex) {
    return guesses[index].length <= letterIndex
        ? ""
        : guesses[index][letterIndex];
  }

  void addLetter(String letter) {
    if (guesses[index].length < selectedWordLength && completed == false) {
      guesses[index] += letter;
    }
    notifyListeners();
  }

  void deleteLetter() {
    if (guesses[index].isNotEmpty && completed == false) {
      guesses[index] = guesses[index].substring(0, guesses[index].length - 1);
    }
    notifyListeners();
  }

  void letterController() {
    for (int i = 0; i < selectedWordLength; i++) {
      if (guesses[index][i] == correctWord[i]) {
        letters[guesses[index][i]] = 3;
      } else if (correctWord.contains(guesses[index][i]) &&
          letters[guesses[index][i]] != 3) {
        letters[guesses[index][i]] = 2;
      } else if (correctWord.contains(guesses[index][i]) == false) {
        letters[guesses[index][i]] = 1;
      }
    }

    notifyListeners();
  }

  Future<int> saveWord({required BuildContext context}) async {
    // word too short = status 1
    // no word in dictionary = status 2
    // game won = status 3
    // game lost = status 4

    if (guesses[index].length < correctWord.length) {
      return 1;
    }

    final bool isWordCorrect = await checkIfWordExists(
      word: guesses[index],
      context: context,
    );

    if (!isWordCorrect) {
      return 2;
    }

    if (guesses[index].length == selectedWordLength) {
      status[index] = true;
      if (guesses[index] == correctWord) {
        if (gameMode == 'unlimited') {
          await _hiveStatistics.addUnlimitedGameStatistics(
            isWinner: true,
            wordLength: selectedWordLength,
            totalTries: selectedTotalTries,
          );
        } else {
          await _statsProvider.addWotdStatistics(isWin: true);
        }

        completed = true;
        letterController();
        notifyListeners();
        return 3;
      }

      if (index == selectedTotalTries - 1) {
        if (gameMode == 'unlimited') {
          await _hiveStatistics.addUnlimitedGameStatistics(
            isWinner: false,
            wordLength: selectedWordLength,
            totalTries: selectedTotalTries,
          );
        } else {
          await _statsProvider.addWotdStatistics(isWin: false);
        }

        letterController();
        completed = true;
        notifyListeners();

        return 4;
      }
      letterController();
      index++;

      notifyListeners();
      return 0;
    }
    notifyListeners();
    return 0;
  }

  Future<void> restartWord() async {
    gameWon = false;
    completed = false;
    index = 0;
    status = [false, false, false, false, false, false];
    guesses = ["", "", "", "", "", ""];
    letters = {
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

  // Words of the day mode
  void changeGameMode({required String newGameMode}) {
    gameMode = newGameMode;
    notifyListeners();
  }

  Future<void> gamePlayChecker() async {
    final String month = (DateTime.now().month).toString();
    final String day = (DateTime.now().day).toString();
    final String currentDate = '$day$month';

    final bool gamePlayedToday = await _hiveWordsOfTheDay
        .checkIfModePlayedToday(currentDate: currentDate);

    if (!gamePlayedToday) {
      await _hiveWordsOfTheDay.setInitialValues(currentDate: currentDate);
    }
  }

  Future<List<int>> getGameStatus() async {
    await gamePlayChecker();
    final List<int> statusList = await _hiveWordsOfTheDay.getGamesStatus();
    return statusList;
  }

  Future<void> setGameStatus({
    required int gameLevel,
    required bool isWinner,
  }) async {
    await _hiveWordsOfTheDay.changeGameStatus(
      gameLevel: gameLevel,
      isWinner: isWinner,
    );

    await _hiveWordsOfTheDay.addUserWords(
      words: guesses,
      gameLevel: gameLevel,
    );

    await _hiveWordsOfTheDay.addCorrectWord(
      correctWord: correctWord,
      gameLevel: gameLevel,
    );
  }

  Future<int> getCurrentGameLevel() async {
    final List<int> gameStatus = await _hiveWordsOfTheDay.getGamesStatus();

    if (gameStatus[0] == 0) {
      return 0;
    } else if (gameStatus[1] == 0) {
      return 1;
    } else {
      return 2;
    }
  }

  Future<List<List<String>>> getUserWords() async {
    final List<List<String>> wordsList =
        await _hiveWordsOfTheDay.getAllUserWords();
    return wordsList;
  }

  Future<List<String>> getCorrectWords() async {
    final List<String> wordsList = await _hiveWordsOfTheDay.getCorrectWords();
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

  // Theme
  void setTheme(AdaptiveThemeMode theme) {
    theme == AdaptiveThemeMode.dark ? isDark = true : isDark = false;
  }
}
