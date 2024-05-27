import 'package:flutter/material.dart';

class HealthRecordListPage extends StatelessWidget {
  const HealthRecordListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Records'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Health Record:', // 건강기록 추가
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Health Record',
                hintText: 'Enter your health record here...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 작성한 건강기록을 저장하는 기능 추가
                // 이 기능은 필요한 작업을 수행할 수 있도록 구현되어야 합니다.
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
