// ignore_for_file: avoid_returning_null_for_void

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:slowotok/src/services/hive/hive_words_of_the_day.dart';
import 'package:slowotok/src/services/providers/stats_provider.dart';
import 'package:slowotok/src/services/providers/words_provider.dart';
import 'package:slowotok/src/services/hive/hive_unlimited.dart';

class MockHiveUnlimited extends Mock implements HiveUnlimited {}

class MockHiveWotd extends Mock implements HiveWordsOfTheDay {}

class MockStats extends Mock implements StatsProvider {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockHiveUnlimited mockHiveUnlimited;
  late MockHiveWotd mockHiveWotd;
  late MockStats mockStats;
  late WordsProvider sut;

  setUp(
    () {
      mockHiveUnlimited = MockHiveUnlimited();
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
      expect(sut.isDialogWide(), false);
      expect(sut.getSelectedDay().toString().substring(0, 10),
          DateTime.now().toString().substring(0, 10));
      expect(sut.isDark(), false);
    },
  );

  test(
    "should change missedDay game status",
    () async {
      sut.setMissedDayStatus(playingMissedDay: true);

      expect(sut.isPlayingMissedDay(), true);
    },
  );

  test(
    "should change game mode",
    () async {
      final String newMode = 'wotd';

      sut.setGameMode(newGameMode: newMode);

      expect(sut.getGameMode(), newMode);
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

          expect(sut.getSelectedTries(), selectedTries);
        },
      );

      test(
        "shoud set word length",
        () async {
          final int selectedLength = 7;

          sut.setWordLength(selectedLength);

          expect(sut.getSelectedWordLength(), selectedLength);
        },
      );

      test(
        "should reset length and tries",
        () async {
          final int length = 5;
          final int tries = 5;

          sut.setTotalTries(tries);
          sut.setWordLength(length);

          expect(sut.getSelectedWordLength(), length);
          expect(sut.getSelectedTries(), tries);

          sut.resetWordLengthAndTries();

          expect(sut.getSelectedWordLength(), 0);
          expect(sut.getSelectedTries(), 0);
        },
      );
    },
  );

  test(
    "should change game status",
    () async {
      sut.setGameEndStatus(isGameWon: true);

      expect(sut.getGameStatus(), true);
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
}
