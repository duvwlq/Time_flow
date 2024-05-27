import 'package:flutter/material.dart';

class AddHealthRecordPage extends StatefulWidget {
  const AddHealthRecordPage({Key? key}) : super(key: key);

  @override
  _AddHealthRecordPageState createState() => _AddHealthRecordPageState();
}

class _AddHealthRecordPageState extends State<AddHealthRecordPage> {
  TextEditingController _bodyConditionController = TextEditingController();
  String _selectedHealthStatus = '보통'; // 초기값은 '보통'으로 설정

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('건강 기록 추가'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '오늘의 건강 상태를 선택하세요:', // 텍스트 변경
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedHealthStatus,
              onChanged: (value) {
                setState(() {
                  _selectedHealthStatus = value!;
                });
              },
              items: <String>['나쁨', '보통', '좋음'] // 옵션 변경
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _bodyConditionController, // 몸 상태 입력 필드에 연결
              decoration: InputDecoration(
                labelText: '몸 상태',
                hintText: '오늘의 몸 상태를 입력하세요...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _saveHealthStatus(context);
              },
              child: Text('저장'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveHealthStatus(BuildContext context) {
    String bodyCondition = _bodyConditionController.text.trim(); // 추가된 몸 상태

    if (bodyCondition.isNotEmpty) { // 몸 상태 입력 확인 추가
      // 여기에 건강 상태와 몸 상태를 저장하는 로직을 추가할 수 있습니다.
      // 예를 들어, 데이터베이스에 저장하거나 API로 전송할 수 있습니다.
      // 이 예제에서는 건강 상태와 몸 상태를 콘솔에 출력합니다.
      print('건강 상태: $_selectedHealthStatus'); // 선택된 건강 상태로 변경
      print('몸 상태: $bodyCondition'); // 입력된 몸 상태 출력

      // 저장 후 화면에 성공적으로 저장되었음을 알리는 SnackBar를 표시합니다.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('건강 상태가 성공적으로 저장되었습니다!'),
        ),
      );
    } else {
      // 입력이 없는 경우 사용자에게 메시지를 표시하여 입력을 유도합니다.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('건강 상태와 몸 상태를 모두 입력해주세요!'), // 메시지 변경
        ),
      );
    }
  }

  @override
  void dispose() {
    // 페이지가 dispose 될 때 컨트롤러를 해제합니다.
    _bodyConditionController.dispose(); // 몸 상태 입력 컨트롤러도 해제
    super.dispose();
  }
}
