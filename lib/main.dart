import 'package:flutter/material.dart';
import 'package:blink_list/onboarding_screen.dart';
import 'package:blink_list/Calender.dart'; // 이 부분은 실제 파일 이름으로 수정해주세요
import 'package:blink_list/healthrecordlistpage.dart'; // 건강 기록 페이지로 수정해주세요
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.notoSansTextTheme(),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => OnBoardingScreen(),
        '/calendar': (context) => SalaryCalendarPage(), // 실제 파일 이름으로 수정
        '/health_records': (context) => HealthRecordListPage(), // 건강 기록 페이지 추가
      },
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ko', 'KR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
