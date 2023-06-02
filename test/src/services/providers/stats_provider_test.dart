// ignore_for_file: avoid_returning_null_for_void

import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

import 'package:slowotok/src/screens/stats_screen/wotd_mode_stats/widgets/event_model.dart';
import 'package:slowotok/src/services/hive/hive_words_of_the_day.dart';
import 'package:slowotok/src/services/providers/stats_provider.dart';
import 'package:slowotok/src/services/hive/hive_unlimited.dart';

class MockHiveUnlimited extends Mock implements HiveUnlimited {}

class MockHiveWotd extends Mock implements HiveWordsOfTheDay {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockHiveUnlimited mockHiveUnlimited;
  late MockHiveWotd mockHiveWotd;
  late StatsProvider sut;

  setUp(
    () {
      mockHiveUnlimited = MockHiveUnlimited();
      mockHiveWotd = MockHiveWotd();

      sut = StatsProvider(
        hiveUnlimited: mockHiveUnlimited,
        hiveWordsOfTheDay: mockHiveWotd,
      );
    },
  );

  test(
    "initial values should be correct",
    () async {
      expect(sut.getDisplayedStatsType(), 'unlimited');
      expect(
        sut.getFocusedDay().toString().substring(0, 10),
        DateTime.now().toString().substring(0, 10),
      );
      expect(
        sut.getSelectedDay().toString().substring(0, 10),
        DateTime.now().toString().substring(0, 10),
      );
    },
  );

  test(
    "should check statistics for unlimited and wotd mode",
    () async {
      when(() => mockHiveUnlimited.checkUnlimitedStats())
          .thenAnswer((invocation) async => null);
      when(() => mockHiveWotd.checkWotdStatistics())
          .thenAnswer((invocation) async => null);

      await sut.checkForStatistics();

      verify(() => mockHiveUnlimited.checkUnlimitedStats()).called(1);
      verify(() => mockHiveWotd.checkWotdStatistics()).called(1);
    },
  );

  test(
    "should change stats type",
    () async {
      final String statsType = 'wotd';

      sut.setDisplayedStatsType(statsType: statsType);
      final String stats = sut.getDisplayedStatsType();

      expect(stats, statsType);
    },
  );

  group("reset button", () {
    test(
      "should be visible",
      () async {
        final String statsType = 'unlimited';
        when(() => sut.getNumberOfGames()).thenReturn(1);

        sut.setDisplayedStatsType(statsType: statsType);
        final bool isVisible = sut.isResetButtonVisible();

        expect(isVisible, true);
      },
    );

    test(
      "should be invisible due to game number",
      () async {
        when(() => sut.getNumberOfGames()).thenReturn(0);

        final bool isVisible = sut.isResetButtonVisible();

        expect(isVisible, false);
      },
    );

    test(
      "should be invisible due to stats type",
      () async {
        final String statsType = 'wotd';
        when(() => sut.getNumberOfGames()).thenReturn(1);

        sut.setDisplayedStatsType(statsType: statsType);
        final bool isVisible = sut.isResetButtonVisible();

        expect(isVisible, false);
      },
    );
  });

  test(
    "should run stats reset",
    () async {
      when(() => mockHiveUnlimited.setInitialStats())
          .thenAnswer((invocation) async => null);

      await sut.resetStatistics();

      verify(() => mockHiveUnlimited.setInitialStats()).called(1);
    },
  );

  test(
    "should return first day of stats",
    () async {
      final Map<String, List<bool>> testData = {
        '2023-06-15': [true, true, true],
        '2023-05-12': [true, true, true],
        '2023-07-02': [true, true, true],
        '2023-04-17': [true, true, true],
      };
      when(() => mockHiveWotd.getWotdStats()).thenReturn(testData);

      final DateTime firstDay = sut.getFirstDay();

      expect(firstDay, DateTime(2023, 4, 17));
    },
  );

  test(
    "should change focused day",
    () async {
      final date = DateTime(2023, 9, 12);

      sut.changeFocusedDay(day: date);
      final DateTime focusedDay = sut.getFocusedDay();

      expect(focusedDay, date);
    },
  );

  test(
    "should change selected day",
    () async {
      final date = DateTime(2023, 4, 2);

      sut.changeSelectedDay(day: date);
      final DateTime selectedDay = sut.getSelectedDay();

      expect(selectedDay, date);
    },
  );

  test(
    "should convert date to phrase",
    () async {
      final date = DateTime(2023, 5, 31);

      final convertedDate = sut.getSelectedDateFormatted(date);

      expect(convertedDate, 'Środa, 31 Maja 2023');
    },
  );

  test(
    "should get stats and convert them",
    () async {
      final Map<String, List<bool>> initialStats = {
        '2023-06-15': [],
        '2023-05-12': [],
        '2023-07-02': [],
        '2023-04-17': [],
      };
      final Map<DateTime, List<Event>> formattedStats = {
        DateTime(2023, 6, 15): [],
        DateTime(2023, 5, 12): [],
        DateTime(2023, 7, 2): [],
        DateTime(2023, 4, 17): [],
      };
      when(() => mockHiveWotd.getWotdStats()).thenReturn(initialStats);

      final stats = sut.getWotdStatistics();

      expect(stats, formattedStats);
    },
  );

  test(
    "should run stats add",
    () async {
      when(() => mockHiveWotd.getWotdStats()).thenReturn({});
      when(() => mockHiveWotd.addWotdStats(
          date: any(named: 'date'),
          dayStats: any(named: 'dayStats'))).thenAnswer((_) async => null);

      await sut.addWotdStatistics(isWin: true);

      verify(() => mockHiveWotd.getWotdStats()).called(1);
      verify(() => mockHiveWotd.addWotdStats(
          date: any(named: 'date'),
          dayStats: any(named: 'dayStats'))).called(1);
    },
  );

  test(
    "should get single day stats",
    () async {
      final List<bool> testStats = [true, false];
      final List<String> expectedOutcome = ['win', 'lose', 'no_data'];
      when(() => mockHiveWotd.getWotdStatsForGivenDay(date: any(named: 'date')))
          .thenReturn(testStats);

      final stats = sut.getSingleDayStats();

      expect(stats, expectedOutcome);
    },
  );

  test(
    "should get number of perfect days in given month",
    () async {
      sut.changeFocusedDay(day: DateTime(2023, 6));
      final Map<String, List<bool>> testStats = {
        '2023-06-02': [true, false, true],
        '2023-06-13': [true, true, true],
        '2023-06-25': [true, false, true],
        '2023-06-30': [true, true, true],
      };
      when(() => mockHiveWotd.getWotdStats()).thenReturn(testStats);

      final numberOfDays = sut.getNumberOfPerfectDaysInMonth();

      expect(numberOfDays, 2);
    },
  );

  test(
    "should return day performance phrase",
    () async {
      final List<List<bool>> testStats = [
        [true, true, true],
        [],
        [true, false],
        [false, true, false],
        [false, false, false],
        [true, false, true],
      ];

      final List<String> expectedPerformance = [
        'perfect',
        'unstarted',
        'unfinished',
        'not-bad',
        'try-again',
        'almost-perfect',
      ];

      for (int i = 0; i < 6; i++) {
        when(() =>
                mockHiveWotd.getWotdStatsForGivenDay(date: any(named: 'date')))
            .thenReturn(testStats[i]);

        final String performance = sut.getDayPerformance();

        expect(performance, expectedPerformance[i]);
        i++;
      }
    },
  );

  test(
    "should reset selected day stats",
    () async {
      when(() => mockHiveWotd.resetStatsForGivenDay(date: any(named: 'date')))
          .thenAnswer((_) async => null);

      sut.changeSelectedDay(day: DateTime(2023, 5, 5));
      sut.resetDayStats();

      verify(() => mockHiveWotd.resetStatsForGivenDay(date: '2023-05-05'))
          .called(1);
    },
  );

  test(
    "should add missing day stats",
    () async {
      when(() => mockHiveWotd.getWotdStatsForGivenDay(date: any(named: 'date')))
          .thenReturn([true]);
      when(() => mockHiveWotd.addWotdStats(
          date: any(named: 'date'),
          dayStats: any(named: 'dayStats'))).thenAnswer((_) async => null);

      await sut.addStatsForMissingDay(isWin: true, date: '2023-05-05');
      final dayStats = mockHiveWotd.getWotdStatsForGivenDay(date: '2023-05-05');

      verify(() =>
              mockHiveWotd.getWotdStatsForGivenDay(date: any(named: 'date')))
          .called(2);
      verify(() => mockHiveWotd.addWotdStats(
          date: any(named: 'date'), dayStats: [true, true])).called(1);
      expect(dayStats, [true, true]);
    },
  );

  group("chevrons visibility", () {
    test(
      "left chevron should not be visible",
      () async {
        when(() => mockHiveWotd.getWotdStats()).thenReturn({
          '2023-05-01': [true, true, true]
        });

        sut.changeFocusedDay(day: DateTime(2023, 5));

        final isVisible = sut.isLeftChevronVisible();

        expect(isVisible, false);
      },
    );
    test(
      "left chevron should be visible",
      () async {
        when(() => mockHiveWotd.getWotdStats()).thenReturn({
          '2023-05-01': [true, true, true]
        });

        sut.changeFocusedDay(day: DateTime(2023, DateTime.now().month));

        final isVisible = sut.isLeftChevronVisible();

        expect(isVisible, true);
      },
    );
    test(
      "right chevron should not be visible",
      () async {
        sut.changeFocusedDay(day: DateTime(2023, DateTime.now().month));

        final isVisible = sut.isRightChevronVisible();

        expect(isVisible, false);
      },
    );
    test(
      "right chevron should be visible",
      () async {
        sut.changeFocusedDay(day: DateTime(2023));

        final isVisible = sut.isRightChevronVisible();

        expect(isVisible, true);
      },
    );
  });
}
