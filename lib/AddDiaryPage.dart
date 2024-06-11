import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // intl 패키지를 임포트하여 날짜 포맷팅을 사용합니다.
import 'dart:async'; // 비동기 프로그래밍을 위한 dart:async 라이브러리를 임포트합니다.
import 'package:path_provider/path_provider.dart'; // 파일 시스템에 액세스하기 위한 path_provider 패키지를 임포트합니다.
import 'dart:io'; // 파일 I/O 작업을 위한 dart:io 라이브러리를 임포트합니다.

class AddDiaryPage extends StatefulWidget {
  @override
  _AddDiaryPageState createState() => _AddDiaryPageState();
}

class _AddDiaryPageState extends State<AddDiaryPage> {
  TextEditingController _diaryController = TextEditingController();
  DateTime _selectedDate = DateTime.now(); // 선택된 날짜를 저장하는 변수입니다.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('일기 작성'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '날짜를 선택하세요:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                _selectDate(context);
              },
              child: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
            ),
            SizedBox(height: 16),
            Text(
              '오늘의 일기를 작성하세요:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _diaryController,
              decoration: InputDecoration(
                labelText: '일기',
                hintText: '오늘의 일기를 작성하세요...',
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _saveDiary(context);
              },
              child: Text('저장'),
            ),
          ],
        ),
      ),
    );
  }

  // 달력에서 날짜를 선택하는 함수입니다.
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  // 일기를 저장하는 함수입니다.
  Future<void> _saveDiary(BuildContext context) async {
    String diary = _diaryController.text.trim();

    if (diary.isNotEmpty) {
      try {
        // 앱의 문서 디렉토리 경로를 가져옵니다.
        Directory directory = await getApplicationDocumentsDirectory();
        String path = directory.path;

        // 일기를 저장할 파일 경로를 지정합니다.
        String filePath = '$path/${DateFormat('yyyy-MM-dd').format(_selectedDate)}.txt';

        // 파일에 일기 내용을 쓰기 위한 File 객체를 생성합니다.
        File file = File(filePath);

        // 파일에 일기 내용을 저장합니다.
        await file.writeAsString(diary);

        // 저장 후 화면에 성공적으로 저장되었음을 알리는 SnackBar를 표시합니다.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('일기가 성공적으로 저장되었습니다!'),
          ),
        );
      } catch (e) {
        print('Error saving diary: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('일기 저장 중 오류가 발생했습니다.'),
          ),
        );
      }
    } else {
      // 입력이 없는 경우 사용자에게 메시지를 표시하여 입력을 유도합니다.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('일기를 작성해주세요!'),
        ),
      );
    }
  }
}
