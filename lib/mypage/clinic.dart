import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

class ClinicScreen extends StatefulWidget {
  const ClinicScreen({super.key});

  @override
  State<ClinicScreen> createState() => _ClinicScreenState();
}

class _ClinicScreenState extends State<ClinicScreen> {
  List<String> selectedChoices = [];

  List<String> choices = [
    '두드러기',
    '입술, 입 주변 부종',
    '오심',
    '복통',
    '오한',
    '콧물',
    '구토',
    '설사',
    '눈물',
    '눈 가려움',
    '목 가려움',
    '기타'
  ];

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeDateFormatting('ko_KR', null),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  const Text('방문한 병원'),
                  const SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(20.0), // 모서리를 원하는 값으로 설정
                        ),
                        labelText: '입력하기',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('방문한 이유'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: choices.map((String choice) {
                      return FilterChip(
                        label: Text(choice),
                        selected: selectedChoices.contains(choice),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              selectedChoices.add(choice);
                            } else {
                              selectedChoices.remove(choice);
                            }
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.0), // 모서리를 둥글게 설정
                          side: BorderSide.none,
                        ),
                        backgroundColor: Colors.grey.shade300, // 밝은 회색 배경색 설정
                        checkmarkColor: Color.fromARGB(
                            255, 13, 212, 63), // 선택된 상태의 체크 아이콘 색상 설정
                        selectedColor: Colors.grey.shade300, // 선택된 상태의 배경색 설정
                        showCheckmark: true, // 체크 아이콘 표시 여부
                        labelStyle:
                            TextStyle(color: Colors.black), // 라벨 텍스트 색상 설정
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  const Text('진료 내용'),
                  const SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(20.0), // 모서리를 원하는 값으로 설정
                        ),
                        labelText: '진료/검사/시술/처방 내역 등',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '전체 진료 내역은 [리포트]에서 한눈에 확인할 수 있어요. 진료받을 때 참고하시면 편해요 :)',
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width -
                        32, // 버튼의 가로 길이를 화면 전체로 설정
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 38, 159, 115),
                      ),
                      child: const Text(
                        '저장하기',
                        style: TextStyle(
                          color: Colors.white, // 텍스트 색상을 하얀색으로 변경
                          fontWeight: FontWeight.bold, // 텍스트 굵게
                        ),
                      ),
                      onPressed: () {
                        if (kDebugMode) {
                          print(selectedChoices);
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  void onDaySelected(DateTime selectDate, DateTime focusedDate) {
    setState(() {
      selectedDate = selectDate;
    });
  }
}
