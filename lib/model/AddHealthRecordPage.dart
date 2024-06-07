import 'package:flutter/material.dart';

class AddHealthRecordPage extends StatelessWidget {
  const AddHealthRecordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

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
