// ignore_for_file: avoid_returning_null_for_void

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:slowotok/src/services/hive/hive_words_of_the_day.dart';
import 'package:slowotok/src/services/providers/stats_provider.dart';
import 'package:slowotok/src/services/providers/words_provider.dart';
import 'package:slowotok/src/services/hive/hive_unlimited.dart';

class MockHiveUnlimited extends Mock implements HiveUnlimited {}

class MockHiveWotd extends Mock implements HiveWordsOfTheDay {}

class MockStats extends Mock implements StatsProvider {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockHiveUnlimited mockHiveUnlimited;
  late MockBuildContext mockContext;
  late MockHiveWotd mockHiveWotd;
  late MockStats mockStats;
  late WordsProvider sut;

  setUp(
    () {
      mockHiveUnlimited = MockHiveUnlimited();
      mockContext = MockBuildContext();
      mockHiveWotd = MockHiveWotd();
      mockStats = MockStats();

      sut = WordsProvider(
        hiveUnlimited: mockHiveUnlimited,
        hiveWordsOfTheDay: mockHiveWotd,
        statsProvider: mockStats,
      );
    },
  );

  test(
    "initial values should be correct",
    () async {
      expect(sut.isPlayingMissedDay(), false);
      expect(sut.getGameMode(), 'unlimited');
      expect(sut.getSelectedTries(), 0);
      expect(sut.getSelectedWordLength(), 0);
      expect(sut.getCorrectWord(), '');
      expect(sut.isCompleted(), false);
      expect(sut.isGameWon(), false);
      expect(sut.getWordIndex(), 0);
      expect(sut.getInstructionDialogPage(), 0);
      expect(sut.getStatusList(), [false, false, false, false, false, false]);
      expect(sut.getGuessesList(), ['', '', '', '', '', '']);
      expect(
        sut.getLetters(),
        {
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
        },
      );
      expect(sut.getDialogPageIndex(), 0);
      expect(sut.isDialogLong(), false);
      expect(sut.getSelectedDay().toString().substring(0, 10),
          DateTime.now().toString().substring(0, 10));
      expect(sut.isDark(), false);
    },
  );

  test(
    "should change missedDay game status",
    () async {
      sut.setMissedDayStatus(playingMissedDay: true);

      final bool isPlayingMissedDay = sut.isPlayingMissedDay();

      expect(isPlayingMissedDay, true);
    },
  );

  test(
    "should change game mode",
    () async {
      final String newMode = 'wotd';

      sut.setGameMode(newGameMode: newMode);
      final String gameMode = sut.getGameMode();

      expect(gameMode, newMode);
    },
  );

  group(
    "word length and total tries",
    () {
      test(
        "should set total tries",
        () async {
          final int selectedTries = 4;

          sut.setTotalTries(selectedTries);
          final int tries = sut.getSelectedTries();

          expect(tries, selectedTries);
        },
      );

      test(
        "shoud set word length",
        () async {
          final int selectedLength = 7;

          sut.setWordLength(selectedLength);
          final int length = sut.getSelectedWordLength();

          expect(length, selectedLength);
        },
      );

      test(
        "should reset length and tries",
        () async {
          final int length = 5;
          final int tries = 6;

          sut.setTotalTries(tries);
          sut.setWordLength(length);

          final int changedLength = sut.getSelectedWordLength();
          final int changedTries = sut.getSelectedTries();
          sut.resetWordLengthAndTries();
          final int resetLength = sut.getSelectedWordLength();
          final int resetTries = sut.getSelectedTries();

          expect(changedLength, 5);
          expect(changedTries, 6);
          expect(resetLength, 0);
          expect(resetTries, 0);
        },
      );
    },
  );

  test(
    "should change game status",
    () async {
      sut.setGameEndStatus(isGameWon: true);
      final bool gameStatus = sut.isGameWon();

      expect(gameStatus, true);
    },
  );

  group(
    "should mark game as lost",
    () {
      test(
        "for unlimited mode",
        () async {
          when(() => mockHiveUnlimited.addUnlimitedGameStats(
                  isWinner: false,
                  wordLength: any(named: 'wordLength'),
                  totalTries: any(named: 'totalTries')))
              .thenAnswer((_) async => null);

          await sut.markGameAsLost();

          verify(() => mockHiveUnlimited.addUnlimitedGameStats(
              isWinner: false,
              wordLength: any(named: 'wordLength'),
              totalTries: any(named: 'totalTries'))).called(1);
        },
      );
      test(
        "for wotd mode",
        () async {
          sut.setGameMode(newGameMode: 'wotd');
          when(() => mockStats.addWotdStatistics(isWin: false))
              .thenAnswer((_) async => null);

          await sut.markGameAsLost();

          verify(() => mockStats.addWotdStatistics(isWin: false)).called(1);
        },
      );
    },
  );

  test(
    "should set new random word",
    () async {
      sut.setWordLength(6);

      await sut.setRandomWord(context: mockContext);

      final String randomWord = sut.getCorrectWord();

      expect(randomWord.length, 6);
    },
  );

  test(
    "should switch to wotd mode and adjust values",
    () async {
      final DateTime testDate = DateTime(2023, 4, 17);
      sut.playWotdMode(date: testDate);
      final int tries = sut.getSelectedTries();
      final int length = sut.getSelectedWordLength();
      final DateTime date = sut.getSelectedDay();
      final String gameMode = sut.getGameMode();

      expect(tries, 6);
      expect(length, 5);
      expect(date, testDate);
      expect(gameMode, 'wordsoftheday');
    },
  );

  test(
    "should change selected day",
    () async {
      final DateTime testDate = DateTime(2023, 4, 17);

      sut.setSelectedDay(date: testDate);
      final selectedDay = sut.getSelectedDay();

      expect(selectedDay, testDate);
    },
  );

  test(
    "should set wotd dialog page",
    () async {
      final int pageIndex = 1;

      sut.setWotdDialogPage(indexPage: pageIndex);
      final savedIndexPage = sut.getDialogPageIndex();

      expect(savedIndexPage, pageIndex);
    },
  );

  test(
    "should set dialog height bool value",
    () async {
      when(() =>
              mockHiveWotd.checkIfWotdPlayedGivenDay(date: any(named: 'date')))
          .thenReturn(true);
      when(() => mockHiveWotd.getGamesStatus()).thenReturn([1, 0, 1]);

      await sut.checkDialogHeight(pageIndex: 1);
      final isDialogLong = sut.isDialogLong();

      expect(isDialogLong, true);
    },
  );

  test(
    "should return game status",
    () async {
      when(() => mockHiveWotd.getWotdStatsForGivenDay(date: any(named: 'date')))
          .thenReturn([true, true]);
      when(() =>
              mockHiveWotd.checkIfWotdPlayedGivenDay(date: any(named: 'date')))
          .thenReturn(true);
      when(() => mockHiveWotd.getGamesStatus()).thenReturn([1, 0, 1]);

      final List<int> gameStatus = await sut.getGameStatus();

      sut.setMissedDayStatus(playingMissedDay: true);
      final List<int> missedDaygameStatus = await sut.getGameStatus();

      expect(gameStatus, [1, 0, 1]);
      expect(missedDaygameStatus, [1, 1, 0]);
    },
  );

  test(
    "should get current game level",
    () async {
      when(() =>
              mockHiveWotd.checkIfWotdPlayedGivenDay(date: any(named: 'date')))
          .thenReturn(true);
      when(() => mockHiveWotd.getGamesStatus()).thenReturn([1, 2, 0]);

      final int gameLevel = await sut.getCurrentGameLevel();

      expect(gameLevel, 2);
    },
  );

  test(
    "should get user words",
    () async {
      final List<String> testWords = ['ARBUZ', 'BANAN', 'METRO'];
      when(() => mockHiveWotd.getAllUserWords()).thenReturn([testWords]);

      final List<List<String>> userWords = sut.getUserWords();

      expect(userWords, [testWords]);
    },
  );
  test(
    "should get correct words",
    () async {
      final List<String> testWords = ['ARBUZ', 'BANAN', 'METRO'];
      when(() => mockHiveWotd.getCorrectWords()).thenReturn(testWords);

      final List<String> correctWords = sut.getCorrectWords();

      expect(correctWords, testWords);
    },
  );

  test(
    "should check if wotd game mode is available",
    () async {
      final List<int> gameStatus = [1, 2, 0];
      when(() =>
              mockHiveWotd.checkIfWotdPlayedGivenDay(date: any(named: 'date')))
          .thenReturn(true);
      when(() => mockHiveWotd.getGamesStatus()).thenReturn(gameStatus);

      final bool isAvailable = await sut.gameModeAvailable();

      expect(isAvailable, true);
    },
  );

  test(
    "should check if word exists",
    () async {
      final bool firstWordExists =
          await sut.checkIfWordExists(word: 'AAAAA', context: mockContext);
      final bool secondWordExists =
          await sut.checkIfWordExists(word: 'ARBUZ', context: mockContext);

      expect(firstWordExists, false);
      expect(secondWordExists, true);
    },
  );

  test(
    "should save user word and return relevant value",
    () async {
      when(() => mockHiveWotd.addWotdStats(
          date: any(named: 'date'),
          dayStats: any(named: 'dayStats'))).thenAnswer((_) async => null);
      when(() => mockHiveWotd.getWotdStats()).thenReturn({});
      when(() => mockHiveUnlimited.addUnlimitedGameStats(
          isWinner: any(named: 'isWinner'),
          wordLength: any(named: 'wordLength'),
          totalTries: any(named: 'totalTries'))).thenAnswer((_) async => null);

      final int wordOutcome1 = await sut.saveWord(context: mockContext);

      sut.setTotalTries(6);
      sut.setWordLength(5);
      await sut.setRandomWord(context: mockContext);
      sut.addLetter('N');
      sut.addLetter('O');
      sut.addLetter('T');
      sut.addLetter('A');
      final int wordOutcome2 = await sut.saveWord(context: mockContext);

      expect(wordOutcome1, 2);
      expect(wordOutcome2, 1);
    },
  );

  test(
    "should restart word",
    () async {
      await sut.restartWord();

      final bool gameWon = sut.isGameWon();
      final bool isCompleted = sut.isCompleted();
      final int index = sut.getWordIndex();
      final List<bool> status = sut.getStatusList();
      final List<String> guesses = sut.getGuessesList();
      final Map<String, int> letters = sut.getLetters();

      expect(gameWon, false);
      expect(isCompleted, false);
      expect(index, 0);
      expect(status, [false, false, false, false, false, false]);
      expect(guesses, ['', '', '', '', '', '']);
      expect(
        letters,
        {
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
        },
      );
    },
  );

  test(
    "should save the game",
    () async {
      when(() => mockHiveWotd.getWotdStatsForGivenDay(date: any(named: 'date')))
          .thenReturn([true, true, false]);
      when(() => mockHiveWotd.addWotdStats(
          date: any(named: 'date'),
          dayStats: any(named: 'dayStats'))).thenAnswer((_) async => null);
      when(() => mockHiveWotd.getGamesStatus()).thenReturn([1, 1, 0]);
      when(() => mockHiveWotd.changeGameStatus(
          gameLevel: any(named: 'gameLevel'),
          isWinner: any(named: 'isWinner'))).thenAnswer((_) async => null);
      when(() => mockHiveWotd.addUserWords(
          words: any(named: 'words'),
          gameLevel: any(named: 'gameLevel'))).thenAnswer((_) async => null);
      when(() => mockHiveWotd.addCorrectWord(
          correctWord: any(named: 'correctWord'),
          gameLevel: any(named: 'gameLevel'))).thenAnswer((_) async => null);
      when(() => mockStats.addStatsForMissingDay(
          isWin: any(named: 'isWin'),
          date: any(named: 'date'))).thenAnswer((_) async => null);

      await sut.saveGame(isWinner: true);
      final int gameLevel = await sut.getCurrentGameLevel();

      sut.setMissedDayStatus(playingMissedDay: true);
      sut.setSelectedDay(date: DateTime(2023, 5, 5));
      await sut.saveGame(isWinner: true);
      final List<int> missedDayGameStatus = await sut.getGameStatus();

      expect(gameLevel, 2);
      expect(missedDayGameStatus, [1, 1, 2]);
    },
  );

  test(
    "should set initial values if wotd not played today",
    () async {
      when(() =>
              mockHiveWotd.checkIfWotdPlayedGivenDay(date: any(named: 'date')))
          .thenReturn(false);
      when(() => mockHiveWotd.setInitialValues(
              currentDate: any(named: 'currentDate')))
          .thenAnswer((_) async => null);

      await sut.gamePlayChecker();

      verify(() =>
              mockHiveWotd.checkIfWotdPlayedGivenDay(date: any(named: 'date')))
          .called(1);
      verify(() => mockHiveWotd.setInitialValues(
          currentDate: any(named: 'currentDate'))).called(1);
    },
  );

  test(
    "should set instruction dialog page",
    () async {
      final int index = 1;

      sut.setInstructionDialogPage(page: index);
      final int pageIndex = sut.getInstructionDialogPage();

      expect(pageIndex, index);
    },
  );

  test(
    "should change current theme",
    () async {
      sut.setTheme(AdaptiveThemeMode.dark);
      final bool isDark = sut.isDark();

      sut.setTheme(AdaptiveThemeMode.light);
      final bool isLight = !sut.isDark();

      expect(isDark, true);
      expect(isLight, true);
    },
  );
}
