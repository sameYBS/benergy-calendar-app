import 'package:flutter/material.dart';
import 'package:app/main_calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:app/schedule_card.dart';
import 'package:app/today_banner.dart';
import 'package:app/schedule_bottom_sheet.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      //새일정버튼
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF0DB2B2),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            builder: (_) => ScheduleBottomSheet(),
            //키보드 가림 해결
            isScrollControlled: true,
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            MainCalendar(),
            SizedBox(height: 8),
            TodayBanner(
              selectedDate: selectedDate,
              count: 0,
            ),
            SizedBox(height: 8),
            ScheduleCard(startTime: 12, endTime: 15, content: '샘플'),
          ],
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
