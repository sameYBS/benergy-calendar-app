import 'package:app/color.dart';
import 'package:flutter/material.dart';

class TodayBanner extends StatelessWidget {
  final DateTime selectedDate; // 선택된 날짜
  final int count; // 일정 개수

  const TodayBanner({
    required this.selectedDate,
    required this.count,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 기본 글꼴
    final textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );

    return Container(
      color: PRIMARY_COLOR,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          // 양 끝으로 배치
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 일정
            Text(
              '${selectedDate.year}.${selectedDate.month}.${selectedDate.day}',
              style: textStyle,
            ),
            // 일정 개수 표시
            Text(
              '$count개',
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
