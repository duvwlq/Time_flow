import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 형식을 위해 추가

// 건강 기록을 추가하는 페이지를 나타내는 StatefulWidget
class AddHealthRecordPage extends StatefulWidget {
  @override
  _AddHealthRecordPageState createState() => _AddHealthRecordPageState();
}

// AddHealthRecordPage의 상태를 관리하는 클래스
class _AddHealthRecordPageState extends State<AddHealthRecordPage> {
  // 몸 상태 입력 필드의 컨트롤러
  TextEditingController _bodyConditionController = TextEditingController();
  // 선택된 건강 상태를 저장하는 변수, 초기값은 '보통'으로 설정
  String _selectedHealthStatus = '보통';
  // 선택된 날짜를 저장하는 변수, 초기값은 현재 날짜로 설정
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('건강 기록 추가'), // 앱바의 제목 설정
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '오늘의 날짜를 선택하세요:', // 날짜 선택 레이블
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () {
                _selectDate(context); // 날짜 선택 함수 호출
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 선택된 날짜를 'yyyy-MM-dd' 형식으로 표시
                    Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                    Icon(Icons.calendar_today), // 캘린더 아이콘 표시
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              '오늘의 건강 상태를 선택하세요:', // 건강 상태 선택 레이블
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedHealthStatus, // 초기값 설정
              onChanged: (value) {
                setState(() {
                  _selectedHealthStatus = value!; // 선택된 값 업데이트
                });
              },
              items: <String>['나쁨', '보통', '좋음'] // 드롭다운 항목 설정
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value), // 항목 텍스트 설정
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _bodyConditionController, // 텍스트 필드 컨트롤러 설정
              decoration: InputDecoration(
                labelText: '몸 상태', // 라벨 텍스트 설정
                hintText: '오늘의 몸 상태를 입력하세요...', // 힌트 텍스트 설정
                border: OutlineInputBorder(), // 외곽선 설정
              ),
              maxLines: 5, // 최대 줄 수 설정
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _saveHealthStatus(context); // 저장 버튼 클릭 시 호출되는 함수
              },
              child: Text('저장'), // 버튼 텍스트 설정
            ),
          ],
        ),
      ),
    );
  }

  // 날짜 선택 함수
  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context, // 빌드 컨텍스트 전달
      initialDate: _selectedDate, // 초기 날짜 설정
      firstDate: DateTime(2000), // 선택 가능한 첫 날짜 설정
      lastDate: DateTime(2101), // 선택 가능한 마지막 날짜 설정
    );
    if (picked != null && picked != _selectedDate) // 날짜가 선택되었을 때
      setState(() {
        _selectedDate = picked; // 선택된 날짜로 업데이트
      });
  }

  // 건강 상태를 저장하는 함수
  void _saveHealthStatus(BuildContext context) {
    String bodyCondition = _bodyConditionController.text.trim(); // 입력된 몸 상태

    if (bodyCondition.isNotEmpty) { // 몸 상태가 비어있지 않을 때
      // 데이터베이스에 저장하거나 API로 전송하는 로직을 여기에 추가할 수 있습니다.
      print('날짜: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}');
      print('건강 상태: $_selectedHealthStatus');
      print('몸 상태: $bodyCondition');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('건강 상태가 성공적으로 저장되었습니다!'), // 성공 메시지
        ),
      );
    } else { // 몸 상태가 비어있을 때
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('건강 상태와 몸 상태를 모두 입력해주세요!'), // 에러 메시지
        ),
      );
    }
  }

  @override
  void dispose() {
    _bodyConditionController.dispose(); // 컨트롤러 해제
    super.dispose(); // 상위 클래스의 dispose 호출
  }
}
