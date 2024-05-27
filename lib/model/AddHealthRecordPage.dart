import 'package:flutter/material.dart';

class AddHealthRecordPage extends StatelessWidget {
  const AddHealthRecordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 여기에 건강기록을 작성하는 UI를 구현하세요
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Health Record'),
      ),
      body: Center(
        child: Text('Add Health Record Page'),
      ),
    );
  }
}
