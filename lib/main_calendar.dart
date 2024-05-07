import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MainCalendar extends StatefulWidget {
  const MainCalendar({Key? key}) : super(key: key);
  // final OnDaySelected onDaySelected;
  // final DateTime selectedDate;

  // MainCalendar({
  //   required this.onDaySelected,
  //   required this.selectedDate,
  // });

  @override
  State<MainCalendar> createState() => _MainCalendarState();
}

class _MainCalendarState extends State<MainCalendar> {
  DateTime selectDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      //한국어
      locale: 'ko_kr',
      onDaySelected: (DateTime selectDay, DateTime focusedDay) {
        setState(() {
          this.selectDay = selectDay;
          this.focusedDay = focusedDay;
        });
      },
      selectedDayPredicate: (DateTime day) {
        // selectedDay 와 동일한 날짜의 모양을 바꿔줍니다.
        return isSameDay(selectDay, day);
      },
/*      selectedDayPredicate: (date) =>
          date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day, */
      firstDay: DateTime(2024, 1, 1),
      lastDay: DateTime(2025, 12, 31),
      focusedDay: focusedDay,
      headerStyle: HeaderStyle(
          titleCentered: false,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          )),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        todayDecoration: BoxDecoration(
          color: Colors.purpleAccent,
        ),
        defaultDecoration: BoxDecoration(
          color: Colors.white,
        ),
        weekendDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: Colors.white,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(100.0),
        ),
        defaultTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
        weekendTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
        selectedTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
        ),
        outsideDaysVisible: false,
      ),
    );
  }
}
