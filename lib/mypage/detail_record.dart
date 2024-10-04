import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  List<String> selectedChoices1 = [];
  List<String> selectedChoices2 = [];

  List<String> choices1 = [
    '계란',
    '새우',
    '밀',
    '메밀',
    '대두',
    '땅콩',
    '고등어',
    '돼지고기',
    '복숭아',
    '토마토',
    '호두',
    '잣',
    '닭고기',
    '소고기',
    '오징어',
    '조개류',
    '홍합',
    '전복',
    '굴',
    '아황산',
    '우유',
    '게',
    '아몬드',
    '약물 등 기타'
  ];
  List<String> choices2 = [
    '먹고난 직후 ~ 수 분',
    '수 시간 후',
    '하루~이틀',
    '몇 주',
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
                  const Text('당시 먹은 음식 성분'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: choices1.map((String choice) {
                      return FilterChip(
                        label: Text(choice),
                        selected: selectedChoices1.contains(choice),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              selectedChoices1.add(choice);
                            } else {
                              selectedChoices1.remove(choice);
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
                  const Text('방문한 장소'),
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
                  const Text('나타난 시기'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: choices2.map((String choice) {
                      return FilterChip(
                        label: Text(choice),
                        selected: selectedChoices2.contains(choice),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              selectedChoices2.clear();
                              selectedChoices2.add(choice);
                            } else {
                              selectedChoices2.remove(choice);
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
                  const Text('당시 상황'),
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
                  const Text(
                    '전체  내역은 [리포트]에서 한눈에 확인할 수 있어요. 진료받을 때 참고하시면 편해요 :)',
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
                          print(selectedChoices1);
                          print(selectedChoices2);
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
