import 'package:flutter/material.dart';
import 'package:blink_list/onboarding_screen.dart';
import 'package:blink_list/Calender.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null); // 한글 날짜 형식 초기화
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.notoSansTextTheme(), // 한글 지원 폰트 설정
      ),
      initialRoute: '/', // 초기 라우트 설정
      routes: {
        '/': (context) => OnBoardingScreen(), // 기본 라우트는 온보딩 스크린
        '/calendar': (context) => SalaryCalendarPage(), // 캘린더 페이지의 라우트
      },
      locale: const Locale('ko', 'KR'), // 기본 로케일을 한국어로 설정
      supportedLocales: const [
        Locale('en', 'US'), // 영어 지원
        Locale('ko', 'KR'), // 한국어 지원
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
