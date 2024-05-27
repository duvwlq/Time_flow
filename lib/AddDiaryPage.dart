import 'package:flutter/material.dart';

class AddDiaryPage extends StatefulWidget {
  const AddDiaryPage({Key? key}) : super(key: key);

  @override
  _AddDiaryPageState createState() => _AddDiaryPageState();
}

class _AddDiaryPageState extends State<AddDiaryPage> {
  TextEditingController _diaryController = TextEditingController();

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

  void _saveDiary(BuildContext context) {
    String diary = _diaryController.text.trim();

    if (diary.isNotEmpty) {
      // 여기에 일기를 저장하는 로직을 추가할 수 있습니다.
      // 예를 들어, 데이터베이스에 저장하거나 파일로 저장할 수 있습니다.
      // 이 예제에서는 일기를 콘솔에 출력합니다.
      print('일기 내용: $diary');

      // 저장 후 화면에 성공적으로 저장되었음을 알리는 SnackBar를 표시합니다.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('일기가 성공적으로 저장되었습니다!'),
        ),
      );
    } else {
      // 입력이 없는 경우 사용자에게 메시지를 표시하여 입력을 유도합니다.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('일기를 작성해주세요!'),
        ),
      );
    }
  }

  @override
  void dispose() {
    // 페이지가 dispose 될 때 컨트롤러를 해제합니다.
    _diaryController.dispose();
    super.dispose();
  }
}
