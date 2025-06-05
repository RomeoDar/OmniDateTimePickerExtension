// lib/components/calendar/calendar.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  /// REQUIRED
  final DateTime initialDate, firstDate, lastDate;
  final ValueChanged<DateTime> onDateChanged;

  /// OPTIONAL
  final bool Function(DateTime)? selectableDayPredicate;

  /// NEW
  final List<DateTime> highlightedDates;
  final ValueChanged<DateTime>? onHighlightedDateTap;

  const Calendar({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateChanged,
    this.selectableDayPredicate,
    this.highlightedDates = const [],
    this.onHighlightedDateTap,
  });

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: firstDate,
      lastDay: lastDate,
      focusedDay: initialDate,
      availableCalendarFormats: const {CalendarFormat.month: 'Month'},
      // Disable days via the original predicate
      enabledDayPredicate: selectableDayPredicate,
      selectedDayPredicate: (d) => _isSameDay(d, initialDate),

      onDaySelected: (selected, focused) {
        // Normal callback always fires
        onDateChanged(selected);

        // Extra callback only for highlighted days
        if (highlightedDates.any((d) => _isSameDay(d, selected))) {
          onHighlightedDateTap?.call(selected);
        }
      },

      /// ==========  CUSTOM CELL DECORATION ==========
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          final bool isHighlighted =
          highlightedDates.any((d) => _isSameDay(d, day));
          if (!isHighlighted) return null; // fall back to default

          return Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}a',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}
