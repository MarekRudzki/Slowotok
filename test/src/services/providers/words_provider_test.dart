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

  setUp(() {
    mockHiveUnlimited = MockHiveUnlimited();
    mockHiveWotd = MockHiveWotd();
    mockStats = MockStats();

    sut = WordsProvider(
      hiveUnlimited: mockHiveUnlimited,
      hiveWordsOfTheDay: mockHiveWotd,
      statsProvider: mockStats,
    );
  });
}
