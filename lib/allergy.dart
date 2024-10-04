// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/mypage/clinic.dart';
import 'package:flutter_banergy/mypage/detail_record.dart';
import 'package:flutter_banergy/mypage/scedule_card.dart';

import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_banergy/mypage/drift_database.dart';
import 'package:get_it/get_it.dart';
import 'package:drift/drift.dart' hide Column;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
  if (kDebugMode) {
    print("Locale 확인했다");
  }
  final database = LocalDatabase();
  GetIt.I.registerSingleton<LocalDatabase>(database);
  runApp(const Recordallergyreactions());
}

class Recordallergyreactions extends StatelessWidget {
  const Recordallergyreactions({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ko', 'KR'),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({
    super.key,
  }); // 생성자

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<String>> _events = {};
  final TextEditingController _eventController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String? content; // 일정 내용 저장용

  double getCalendarHeight() {
    // 현재 달력의 표시 형식에 따라 높이를 조절합니다.
    switch (_calendarFormat) {
      case CalendarFormat.month:
        return 400.0; // 월 형식일 경우 높이
      case CalendarFormat.twoWeeks:
        return 300.0; // 2주 형식일 경우 높이
      case CalendarFormat.week:
      default:
        return 200.0; // 주 형식일 경우 높이
    }
  }

// 해당 날짜의 이벤트를 가져오는 함수
  List<String> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  Future<void> _onSubmitted(DateTime dday, String event) async {
    print("Submitted event: $event");
    final selectedDay = _selectedDay ?? _focusedDay;
    if (formkey.currentState != null && formkey.currentState!.validate()) {
      print("Content befor form saved: $event");
      formkey.currentState!.save(); // 내용 저장
      print("Content after form saved: $event");

      // content가 null이 아닌지 확인 후 데이터베이스에 저장
      if (event != null) {
        await GetIt.I<LocalDatabase>().createSchedule(
          SchedulesCompanion(
            content: Value(event!),
            date: Value(selectedDay),
          ),
        );
        print("Event added to database: $event at $selectedDay"); // 저장 로그 추가
      } else {
        // content가 null인 경우의 예외 처리
        print("Content is null. Cannot save to database.");
      }
    }
    print("끝 $event");
  }

// 시간값 검증
  String? timeValidator(String? val) {
    if (val == null) {
      return '값을 입력해주세요';
    }

    int? number;

    try {
      number = int.parse(val);
    } catch (e) {
      return '숫자를 입력해주세요';
    }

    if (number < 0 || number > 24) {
      return '0시부터 24시 사이를 입력해주세요';
    }

    return null;
  }

  // 내용값 검증
  String? contentValidator(String? val) {
    if (val == null || val.length == 0) {
      return '값을 입력해주세요';
    }

    return null;
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.black),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ClinicScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: getCalendarHeight(), // 원하는 최대 높이 설정
              ),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Colors.black, width: 2.0), // 검은 테두리 추가
              ),
              child: WeekCalendar(
                selectedDay: _selectedDay,
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                events: _events,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
              ),
            ),
            Container(
                child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20.0),
                    children: [
                  Container(
                      padding: EdgeInsets.all(20.0),
                      child:
                          Text('안녕하세요? OO님', style: TextStyle(fontSize: 18))),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text('알레르기 반응이 있었나요?',
                          style: TextStyle(fontSize: 16))),
                ])),
            Container(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20.0),
                children: [
                  SizedBox(
                    // database의 데이터가 stream으로 넘어옴.
                    child: StreamBuilder<List<Schedule>>(
                      stream:
                          GetIt.I<LocalDatabase>().watchSchedules(_selectedDay),
                      builder: (context, snapshot) {
                        print("${_selectedDay}");
                        print("${snapshot}");
                        print("${!snapshot.hasData}");
                        //print("${snapshot.data!.isEmpty}");
                        print("${snapshot.data?.isEmpty ?? true}");
                        // 데이터가 없을 때 빈 컨테이너 전달
                        if (snapshot.data?.isEmpty ?? true) {
                          return Container();
                        }
                        print("Snapshot data: ${snapshot.data}");
                        print("Snapshot length: ${snapshot.data?.length}");
                        print("2 확인했다");
                        //print("${snapshot.data!.length} | ${context}");
                        print("${snapshot}");
                        print("${!snapshot.hasData}");
                        //print("${snapshot.data!.isEmpty}");
                        print("${snapshot.data?.isEmpty ?? true}");
                        // 화면 랜더링
                        return ListView.builder(
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            print("Building item at index: $index");
                            final schedule = snapshot.data![index];
                            print("4 확인했다");
                            return Dismissible(
                              key: ObjectKey(schedule.id),
                              direction: DismissDirection.startToEnd,
                              onDismissed: (DismissDirection direction) {
                                GetIt.I<LocalDatabase>()
                                    .removeSchedule(schedule.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "${schedule.content}이(가) 삭제되었습니다.")),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8,
                                  left: 8,
                                ),
                                child: MemoCard(
                                  content: schedule.content,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  MemoCard(
                    content: '강아지',
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true, // 배경을 채우기 위해 true로 설정
                        fillColor: Colors.grey.shade200, // 배경색 설정
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0), // 내부 패딩 설정
                        alignLabelWithHint: true, // 힌트 텍스트를 입력창 하단에 정렬
                        hintText: '몸 상태와 반응 등 증상을 꼭 이야기해주세요.',
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10.0), // 모서리를 원하는 값으로 설정
                          borderSide: BorderSide(
                              color: Colors.grey.shade200), // 테두리 선 색상 설정
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ClinicScreen()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 183, 183, 183)),
                          child: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const RecordScreen()),
                              );
                            },
                            iconSize: 32,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '기록 추가하기',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    margin: EdgeInsets.all(20.0),
                    child: Form(
                      key: formkey,
                      child: CustomTextField(
                        controller: _eventController,
                        label: '메모를 자유롭게 남겨보세요!',
                        onSaved: (String? val) {
                          content = val;
                        },
                        validator: contentValidator,
                        onFieldSubmitted: (text) {
                          // 현재 시간을 가져옴
                          DateTime currentTime = DateTime.utc(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                          );
                          _onSubmitted(currentTime, text); // 입력된 텍스트와 시간을 전달
                          _eventController.clear(); // 입력 필드 비우기
                        },
                      ),
                    ),

                    // 내용 입력 필드
                  ),
                  const SizedBox(height: 8),
                  const Text('병원진료'),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ClinicScreen()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 183, 183, 183)),
                          child: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ClinicScreen()),
                              );
                            },
                            iconSize: 32,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '기록 추가하기',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeekCalendar extends StatefulWidget {
  final DateTime? selectedDay;
  final DateTime focusedDay;
  final CalendarFormat calendarFormat;
  final Map<DateTime, List<String>> events;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(CalendarFormat) onFormatChanged;

  const WeekCalendar({
    Key? key,
    required this.selectedDay,
    required this.focusedDay,
    required this.calendarFormat,
    required this.events,
    required this.onDaySelected,
    required this.onFormatChanged,
  }) : super(key: key);

  @override
  _WeekCalendarState createState() => _WeekCalendarState();
}

class _WeekCalendarState extends State<WeekCalendar> {
  late final ValueNotifier<List<String>> _selectedEvents;
  DateTime? _selectedDay;
  late DateTime _focusedDay;
  late CalendarFormat _calendarFormat;
  final TextEditingController _eventController = TextEditingController();

  double _calendarHeight = 150.0;
  @override
  void initState() {
    super.initState();
    _selectedDay = widget.selectedDay;
    _focusedDay = widget.focusedDay;
    _calendarFormat = widget.calendarFormat;
    _selectedEvents =
        ValueNotifier(_getEventsForDay(_selectedDay ?? _focusedDay));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    _eventController.dispose();
    super.dispose();
  }

  List<String> _getEventsForDay(DateTime day) {
    return widget.events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
      widget.onDaySelected(selectedDay, focusedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar<String>(
          locale: 'ko_KR',
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              final isFocusedDay = isSameDay(day, focusedDay);
              return Center(
                child: Text(
                  DateFormat('d').format(day),
                  style: TextStyle(),
                ),
              );
            },
            selectedBuilder: (context, day, focusedDay) {
              final isFocusedDay = isSameDay(day, focusedDay);
              return Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      DateFormat('d').format(day),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
            todayBuilder: (context, day, focusedDay) {
              final isFocusedDay = isSameDay(day, focusedDay);
              return Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      DateFormat('d').format(day),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          daysOfWeekHeight: 30,
          firstDay: DateTime.utc(2024, 7, 1),
          lastDay: DateTime.utc(2024, 10, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          headerStyle: const HeaderStyle(
            titleCentered: false,
            formatButtonVisible: false,
          ),
          onDaySelected: _onDaySelected,
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
              widget.onFormatChanged(format);
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay; // No need to call setState here
          },
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekendStyle: TextStyle(color: Colors.red),
          ),
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }

  Widget _buildDayCell(BuildContext context, DateTime day,
      {bool isSelected = false, bool isToday = false}) {
    return Column(
      children: [
        // 상단의 긴 줄
        Container(
          height: 2, // 선의 두께
          color: Colors.black, // 선의 색깔
        ),
        // 날짜
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.0), // 날짜와 선 사이의 여백
          child: Center(
            child: Text(
              DateFormat('d').format(day),
              style: TextStyle(
                fontWeight:
                    isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Colors.white
                    : isToday
                        ? Colors.black
                        : Colors.black,
              ),
            ),
          ),
        ),
        // 하단의 긴 줄
        Container(
          height: 2, // 선의 두께
          color: Colors.black, // 선의 색깔
        ),
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextEditingController controller; // 컨트롤러 추가

  const CustomTextField({
    required this.label,
    required this.onSaved,
    required this.validator,
    this.onFieldSubmitted,
    required this.controller, // 컨트롤러를 받는 매개변수 추가
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      // 세로로 텍스트와 텍스트 필드를 위치
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color.fromARGB(255, 19, 160, 104),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          child: TextFormField(
            controller: controller, // TextEditingController를 여기서 사용
            onSaved: onSaved,
            validator: validator,
            keyboardType: TextInputType.multiline, // ➌ 일반 글자 키보드 보여주기
            onFieldSubmitted: onFieldSubmitted, // 추가
          ),
        ),
      ],
    );
  }
}
