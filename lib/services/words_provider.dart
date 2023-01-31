import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

class WordsProvider with ChangeNotifier {
  List<bool> status = [false, false, false, false, false, false];
  List<String> guesses = ["", "", "", "", "", "", ""];
  String correctWord = '';
  int wordLength = 0;
  bool completed = false;
  int index = 0;

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

  Future<int> saveWord() async {
    if (guesses[index].length == wordLength) {
      status[index] = true;
      if (guesses[index] == correctWord) {
        completed = true;
        letterController();
        notifyListeners();
        return 1;
      }

      if (wordLength == 4) {
        if (index == wordLength + 1) {
          letterController();
          completed = true;
          notifyListeners();

          return 3;
        }
      }

      if (wordLength == 5) {
        if (index == wordLength) {
          letterController();
          completed = true;
          notifyListeners();

          return 3;
        }
      }

      if (wordLength == 6) {
        if (index == wordLength - 1) {
          letterController();
          completed = true;
          notifyListeners();

          return 3;
        }
      }

      if (wordLength == 7) {
        if (index == wordLength - 2) {
          letterController();
          completed = true;
          notifyListeners();

          return 3;
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
