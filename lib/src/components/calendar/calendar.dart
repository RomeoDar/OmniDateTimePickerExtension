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
      rowHeight: 40,
      availableCalendarFormats: const {CalendarFormat.month: 'Month'},
      // Disable days via the original predicate
      enabledDayPredicate: selectableDayPredicate,
      selectedDayPredicate: (d) => _isSameDay(d, initialDate),
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        leftChevronMargin: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
        rightChevronMargin: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
        leftChevronPadding: EdgeInsets.symmetric(horizontal: 0),
        rightChevronPadding: EdgeInsets.symmetric(horizontal: 0),

        titleTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
      ),
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
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black, // Black border color
                width: 1.5,          // Border thickness (adjust as needed)
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: const TextStyle(
                color: Colors.black,    // Black text color
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
        selectedBuilder: (context, day, focusedDay) {
          return Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.black, // change as you want
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black,
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
        todayBuilder: (context, day, focusedDay) {
          final bool isSelected = _isSameDay(day, initialDate);
          final bool isHighlighted = highlightedDates.any((d) => _isSameDay(d, day));

          return Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isHighlighted || isSelected ? Colors.transparent : Colors.transparent,
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}
