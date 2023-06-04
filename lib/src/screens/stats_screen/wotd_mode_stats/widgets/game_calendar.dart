import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

import '/src/services/providers/words_provider.dart';
import '/src/services/providers/stats_provider.dart';
import 'event_model.dart';

class GameCalendar extends StatelessWidget {
  const GameCalendar({
    super.key,
    required this.statsProvider,
  });

  final StatsProvider statsProvider;

  @override
  Widget build(BuildContext context) {
    final isDark =
        context.select((WordsProvider wordsProvider) => wordsProvider.isDark());

    int getHashCode(DateTime key) {
      return key.day * 10000 + key.month * 1000 + key.year;
    }

    final _kEventSource = statsProvider.getWotdStatistics();
    final kEvents = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_kEventSource);

    return Container(
      color: const Color.fromARGB(67, 163, 162, 162),
      child: TableCalendar(
        focusedDay: statsProvider.getFocusedDay(),
        firstDay: statsProvider.getFirstDayOfStats(),
        lastDay: DateTime.now(),
        locale: 'pl_PL',
        weekendDays: [
          DateTime.sunday,
          DateTime.saturday,
        ],
        eventLoader: (day) {
          return kEvents[day] ?? [];
        },
        selectedDayPredicate: (day) {
          return isSameDay(day, statsProvider.getSelectedDay());
        },
        enabledDayPredicate: (day) {
          bool shouldBeVisible = true;
          if (day.month != statsProvider.getFocusedDay().month) {
            shouldBeVisible = false;
          }
          return shouldBeVisible;
        },
        rowHeight: MediaQuery.of(context).size.height * 0.07,
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: isDark
                ? const Color.fromARGB(123, 158, 158, 158)
                : Colors.green.shade200,
          ),
          defaultTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
          disabledTextStyle: TextStyle(
            color: Theme.of(context).dividerColor,
          ),
          todayTextStyle: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
          isTodayHighlighted: false,
          weekendTextStyle: const TextStyle(
            color: Colors.red,
          ),
        ),
        onPageChanged: (focusedDay) {
          if (focusedDay.month == DateTime.now().month) {
            statsProvider.changeSelectedDay(day: DateTime.now());
          } else {
            statsProvider.changeSelectedDay(day: focusedDay);
          }
          statsProvider.changeFocusedDay(day: focusedDay);
        },
        onDaySelected: (selectedDay, focusedDay) {
          statsProvider.changeSelectedDay(day: selectedDay);
        },
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerStyle: HeaderStyle(
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: Theme.of(context).colorScheme.primary,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.primary,
          ),
          leftChevronVisible: statsProvider.isLeftChevronVisible(),
          rightChevronVisible: statsProvider.isRightChevronVisible(),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          headerPadding: buildHeaderPadding(statsProvider: statsProvider),
          titleCentered: true,
          formatButtonVisible: false,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
          weekendStyle: const TextStyle(
            color: Colors.red,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (BuildContext context, date, events) {
            final bool markerOutOfMonth = date.toString().substring(0, 7) !=
                statsProvider.getFocusedDay().toString().substring(0, 7);

            if (events.isEmpty || markerOutOfMonth) {
              return const SizedBox();
            } else {
              final myEvents = events as List<Event>;

              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: myEvents.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(top: 28),
                    padding: const EdgeInsets.all(1.5),
                    child: Container(
                      width: 6.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            myEvents[index].isWin ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

EdgeInsets buildHeaderPadding({required StatsProvider statsProvider}) {
  final bool leftVisible = statsProvider.isLeftChevronVisible();
  final bool rightVisible = statsProvider.isRightChevronVisible();

  if (leftVisible && rightVisible) {
    return const EdgeInsets.symmetric(vertical: 8);
  } else if (leftVisible && !rightVisible) {
    return const EdgeInsets.fromLTRB(0, 8, 64, 8);
  } else if (!leftVisible && rightVisible) {
    return const EdgeInsets.fromLTRB(64, 8, 0, 8);
  } else {
    return const EdgeInsets.symmetric(vertical: 16);
  }
}
