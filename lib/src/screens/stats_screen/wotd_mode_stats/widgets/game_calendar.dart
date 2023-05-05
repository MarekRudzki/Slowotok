import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:slowotok/src/services/providers/stats_provider.dart';

import 'package:table_calendar/table_calendar.dart';

class Event {
  const Event({required this.isWin});

  final bool isWin;
}

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

    final _kEventSource = {
      //TODO this is dummy data
      DateTime(2023, 5): [
        const Event(isWin: true),
        const Event(isWin: false),
        const Event(isWin: true),
      ],
      DateTime(2023, 5, 2): [
        const Event(isWin: true),
        const Event(isWin: false),
        const Event(isWin: false),
      ],
      DateTime(2023, 5, 3): [
        const Event(isWin: true),
        const Event(isWin: true),
        const Event(isWin: true)
      ],
      DateTime(2023, 5, 4): [
        const Event(isWin: false),
        const Event(isWin: true),
        const Event(isWin: false)
      ],
      DateTime(2023, 5, 5): [
        const Event(isWin: false),
        const Event(isWin: false),
        const Event(isWin: true),
      ],
    };
    final kEvents = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_kEventSource);

    final firstDayOfMonth =
        DateTime.utc(DateTime.now().year, DateTime.now().month);
    final lastDayOfMonth = DateTime(2024);

    return Container(
      color: const Color.fromARGB(136, 226, 224, 224),
      child: TableCalendar(
        focusedDay: statsProvider.focusedDay,
        firstDay: firstDayOfMonth,
        lastDay: lastDayOfMonth,
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
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekendStyle: TextStyle(
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
