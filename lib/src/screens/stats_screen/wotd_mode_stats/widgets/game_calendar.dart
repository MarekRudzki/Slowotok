import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';

import 'event_model.dart';
import '/src/services/providers/stats_provider.dart';

class GameCalendar extends StatelessWidget {
  const GameCalendar({
    super.key,
    required this.statsProvider,
  });

  final StatsProvider statsProvider;

  @override
  Widget build(BuildContext context) {
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
        firstDay: statsProvider.getFirstDay(),
        lastDay: DateTime.now(),
        locale: 'pl_PL',
        weekendDays: [
          DateTime.sunday,
          DateTime.saturday,
        ],
        eventLoader: (day) {
          return kEvents[day] ?? [];
        },
        calendarStyle: CalendarStyle(
          selectedDecoration: const BoxDecoration(
            color: Colors.red,
          ),
          defaultTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
          disabledTextStyle: TextStyle(
            color: Theme.of(context).dividerColor,
          ),
          todayTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.green.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          weekendTextStyle: const TextStyle(
            color: Colors.red,
          ),
        ),
        onPageChanged: (focusedDay) {
          statsProvider.changeFocusedDay(day: focusedDay);
        },
        onDaySelected: (selectedDay, focusedDay) {
          statsProvider.changeSelectedDay(day: selectedDay);
        },
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerStyle: HeaderStyle(
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
            if (events.isEmpty) {
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

  if (leftVisible && !rightVisible) {
    return const EdgeInsets.fromLTRB(0, 10, 64, 10);
  } else if (!leftVisible && rightVisible) {
    return const EdgeInsets.fromLTRB(64, 10, 0, 10);
  } else {
    return const EdgeInsets.symmetric(vertical: 20);
  }
}
