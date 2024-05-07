import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:app/home_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

// Table Calendar 사용법
void main() async {
  await initializeDateFormatting();
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
