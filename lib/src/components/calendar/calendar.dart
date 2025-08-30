import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  final DateTime initialDate, firstDate, lastDate;
  final ValueChanged<DateTime> onDateChanged;

  final bool Function(DateTime)? selectableDayPredicate;

  final List<DateTime> highlightedDates;
  final ValueChanged<DateTime>? onHighlightedDateTap;

  final bool autoSelectInitialDate;

  const Calendar({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateChanged,
    this.selectableDayPredicate,
    this.highlightedDates = const [],
    this.onHighlightedDateTap,
    this.autoSelectInitialDate = true,
  });

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.autoSelectInitialDate ? widget.initialDate : null;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: Localizations.localeOf(context).toLanguageTag(),
      firstDay: widget.firstDate,
      lastDay: widget.lastDate,
      focusedDay: widget.initialDate,
      calendarStyle: const CalendarStyle(outsideDaysVisible: false),
      rowHeight: 40,
      availableCalendarFormats: const {CalendarFormat.month: 'Month'},
      // Disable days via the original predicate
      enabledDayPredicate: widget.selectableDayPredicate,
      selectedDayPredicate: (d) => _selectedDate != null && _isSameDay(d, _selectedDate!),
      headerStyle: HeaderStyle(
        titleTextFormatter: (date, locale) {
          final localeName = locale?.toString() ?? Intl.defaultLocale ?? 'en_US';
          final month = DateFormat.MMMM(localeName).format(date);
          return '${month[0].toUpperCase()}${month.substring(1)} ${date.year}';
        },
        titleCentered: true,
        formatButtonVisible: false,
        leftChevronMargin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        rightChevronMargin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
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
        setState(() {
          _selectedDate = selected;
        });

        // Normal callback always fires
        widget.onDateChanged(selected);

        // Extra callback only for highlighted days
        if (widget.highlightedDates.any((d) => _isSameDay(d, selected))) {
          widget.onHighlightedDateTap?.call(selected);
        }
      },

      /// ==========  CUSTOM CELL DECORATION ==========
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          final bool isHighlighted =
          widget.highlightedDates.any((d) => _isSameDay(d, day));
          if (!isHighlighted) return null; // fall back to default
          return Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black, // Black border color
                width: 1.5, // Border thickness (adjust as needed)
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: const TextStyle(
                color: Colors.black, // Black text color
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
          final bool isSelected = _selectedDate != null && _isSameDay(day, _selectedDate!);
          final bool isHighlighted =
          widget.highlightedDates.any((d) => _isSameDay(d, day));

          return Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isHighlighted || isSelected
                    ? Colors.black
                    : Colors.transparent,
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
