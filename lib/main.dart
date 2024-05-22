import 'package:flutter/material.dart';
import 'package:blink_list/onboarding_screen.dart';
import 'package:blink_list/Calender.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // 초기 라우트 설정
      routes: {
        '/': (context) => OnBoardingScreen(), // 기본 라우트는 온보딩 스크린
        '/calendar': (context) => SalaryCalendarPage(), // 캘린더 페이지의 라우트
      },
    );
  }
}
