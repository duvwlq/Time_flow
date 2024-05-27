import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:blink_list/home_page.dart';
import 'package:blink_list/intro_screens/intro_page_1.dart';
import 'package:blink_list/Calender.dart';
import 'package:blink_list/AddHealthRecordPage.dart';
import 'package:blink_list/AddDiaryPage.dart'; // AddDiaryPage import 추가

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController pageController = PageController();
  int currentPage = 0;
  final List<Widget> _navIndex = [
    IntroPage1(),
    HomePage(),
    SalaryCalendarPage(),
    AddHealthRecordPage(),
    AddDiaryPage(), // 일기 페이지 추가
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _navIndex.elementAt(currentPage),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.blue,
        unselectedItemColor: Colors.blueGrey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_books_outlined),
            label: '메인',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_books_outlined),
            label: '일정',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: '입출금 달력',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: '건강 기록 추가',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notes), // 일기 아이콘 추가
            label: '일기 작성', // 일기 라벨 추가
          ),
        ],
        currentIndex: currentPage,
        onTap: _onNavTapped,
      ),
    );
  }

  void _onNavTapped(int index) {
    setState(() {
      currentPage = index;
    });
  }
}
