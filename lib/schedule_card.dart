import 'package:app/color.dart';
import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final int startTime;
  final int endTime;
  final String content;

  const ScheduleCard({
    required this.startTime,
    required this.endTime,
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: PRIMARY_COLOR,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          // 높이를 내부 위젯들의 최대 높이로 설정
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 시간 위젯
              _Time(
                startTime: startTime,
                endTime: endTime,
              ),
              SizedBox(width: 16.0),

              // 일정 내용 위젯
              _Content(
                content: content,
              ),
              SizedBox(width: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}

///////////////
// 자식 위젯들 생성

// 시간을 표시할 위젯 생성
class _Time extends StatelessWidget {
  final int startTime; // 시작 시간
  final int endTime; // 종료 시간

  const _Time({
    required this.startTime,
    required this.endTime,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: PRIMARY_COLOR,
      fontSize: 16.0,
    );

    return Column(
      // 일정을 세로로 배치
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          // 숫자가 한 자리면 0으로 채워기
          '${startTime.toString().padLeft(2, '0')}:00',
          style: textStyle,
        ),
        Text(
          '${endTime.toString().padLeft(2, '0')}:00', // 숫자가 두 자리수가 안 되면 0으로 채워주기
          style: textStyle.copyWith(
            fontSize: 10.0,
          ),
        ),
      ],
    );
  }
}

// 내용을 표시할 위젯
class _Content extends StatelessWidget {
  final String content; // 내용

  const _Content({
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // 최대한 넓게 늘리기
      child: Text(
        content,
      ),
    );
  }
}
