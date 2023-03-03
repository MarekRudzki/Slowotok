import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

class WordsProvider with ChangeNotifier {
  final statsBox = Hive.box('statsBox');

  List<bool> status = [false, false, false, false, false, false];
  List<String> guesses = ["", "", "", "", "", "", ""];
  int index = 0;
  String correctWord = '';
  bool completed = false;
  bool gameWon = false;
  int selectedTotalTries = 0;
  int wordLength = 0;

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

  void setWordLength(int length) {
    wordLength = length;
    notifyListeners();
  }

  void setTotalTries(int tries) {
    selectedTotalTries = tries;
    notifyListeners();
  }

  void setCorrectWord(String word) {
    correctWord = word.toUpperCase();
    notifyListeners();
  }

  Future<String> getRandomWord({
    required BuildContext context,
  }) async {
    final lettersList = await DefaultAssetBundle.of(context)
        .loadString('assets/${wordLength}_letter_words.txt');

    final LineSplitter ls = const LineSplitter();
    final List<String> convertedList = ls.convert(lettersList);

    final random = Random();
    final randomWord = convertedList[random.nextInt(convertedList.length)];
    setCorrectWord(randomWord);

    return randomWord;
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

  String getItem(int index, int letterIndex) {
    return guesses[index].length <= letterIndex
        ? ""
        : guesses[index][letterIndex];
  }

  void addLetter(String letter) {
    if (guesses[index].length < wordLength && completed == false) {
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
    for (int i = 0; i < wordLength; i++) {
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

    if (guesses[index].length == wordLength) {
      status[index] = true;
      if (guesses[index] == correctWord) {
        completed = true;
        gameWon = true;
        letterController();
        notifyListeners();
        return 3;
      }

      if (wordLength == 4) {
        if (index == selectedTotalTries - 1) {
          letterController();
          completed = true;
          notifyListeners();

          return 4;
        }
      }

      if (wordLength == 5) {
        if (index == selectedTotalTries - 1) {
          letterController();
          completed = true;
          notifyListeners();

          return 4;
        }
      }

      if (wordLength == 6) {
        if (index == selectedTotalTries - 1) {
          letterController();
          completed = true;
          notifyListeners();

          return 4;
        }
      }

      if (wordLength == 7) {
        if (index == selectedTotalTries - 1) {
          letterController();
          completed = true;
          notifyListeners();

          return 4;
        }
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
    status = [false, false, false, false, false, false];
    guesses = ["", "", "", "", "", "", ""];
    completed = false;
    gameWon = false;
    index = 0;

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
}
