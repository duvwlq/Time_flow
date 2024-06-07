import 'package:flutter/material.dart'; 
import 'package:table_calendar/table_calendar.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salary Calendar',
      theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple[50], 
          elevation: 0, 
        ),
      ),
      home: SalaryCalendarPage(),
    );
  }
}

class SalaryCalendarPage extends StatefulWidget {
  @override
  _SalaryCalendarPageState createState() => _SalaryCalendarPageState();
}

class _SalaryCalendarPageState extends State<SalaryCalendarPage> {
  late Map<DateTime, List<Map<String, dynamic>>> _transactions; // 거래 정보를 저장하는 맵입니다.
  late DateTime _selectedDay; // 사용자가 선택한 날짜를 저장.
  late DateTime _focusedDay; // 포커스된 날짜를 저장.

  @override
  void initState() {
    super.initState();
    _transactions = {}; // 거래 정보를 초기화.
    _selectedDay = DateTime.now(); // 현재 날짜를 선택한 날짜로 설정.
    _focusedDay = DateTime.now(); // 현재 날짜를 포커스된 날짜로 설정.
    _loadTransactions(); // 거래 정보를 불러옵니다.
  }

  // 사용자의 거래 정보를 로드.
  Future<void> _loadTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? transactionsString = prefs.getString('transactions');
    if (transactionsString != null) {
      setState(() {
        _transactions = transactionsString.split(';').fold<Map<DateTime, List<Map<String, dynamic>>>>({}, (map, entry) {
          final parts = entry.split('|');
          final date = DateTime.parse(parts[0]);
          final transactions = parts.sublist(1).map((item) {
            final itemParts = item.split(':');
            return {
              'type': itemParts[0],
              'amount': double.parse(itemParts[1]),
            };
          }).toList();
          map[date] = transactions;
          return map;
        });
      });
    }
  }

  // 사용자의 거래 정보를 저장 
  Future<void> _saveTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final transactionsString = _transactions.entries.map((entry) {
      final date = entry.key.toIso8601String();
      final transactions = entry.value.map((item) => '${item['type']}:${item['amount']}').join('|');
      return '$date|$transactions';
    }).join(';');
    await prefs.setString('transactions', transactionsString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50], // 배경색을 설정
      appBar: AppBar(
        title: Text('월급 계산 달력'), // 앱 바의 제목을 설정 
        backgroundColor: Colors.deepPurple[50], // 앱 바의 배경색을 설정 
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'ko_KR', // 달력의 로케일을 설정 
            firstDay: DateTime.utc(2010, 10, 16), // 달력의 첫 번째 날짜를 설정 
            lastDay: DateTime.utc(2030, 3, 14), // 달력의 마지막 날짜를 설정 
            headerStyle: HeaderStyle(
              titleCentered: true, // 달력 헤더의 타이틀을 가운데 정렬 
              formatButtonVisible: false, // 달력 헤더의 포맷 버튼을 숨깁니다.
            ),
            focusedDay: _focusedDay, // 포커스된 날짜를 설정 
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day), // 선택된 날짜를 설정 
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _showInputDialog(selectedDay); // 거래 입력 다이얼로그를 표시 
            },
            eventLoader: (day) {
              return _transactions[day] ?? []; // 이벤트를 로드 
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildMarkers(events.cast<Map<String, dynamic>>()),
                  );
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Column(
              children: [
                Text(
                  '내가 번 돈: ${_calculateTotalSalary(_focusedDay).toInt()}원', // 포커스된 달의 총 수입을 표시 
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 20),
                _buildTransactionList(_selectedDay), // 거래 리스트를 표시 
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 거래 입력 다이얼로그를 표시 
  Future<void> _showInputDialog(DateTime date) async {
    double amount = 0.0;
    String type = '월급';
    double? result = await showDialog<double>(
        context: context,
        builder: (BuildContext context) {
      return AlertDialog(
          title: Text('거래 입력'), // 다이얼로그의 제목을 설정 
    content: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
    DropdownButtonFormField<String>(
    value: type,
      items: ['월급', '출금', '입금'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        type = newValue!;
      },
      decoration: InputDecoration(labelText: '거래 유형'),
    ),
      TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: '금액을 입력하세요'),
        onChanged: (value) {
          amount = double.tryParse(value) ?? 0.0;
        },
      ),
    ],
    ),
        actions: <Widget>[
          TextButton(
            child: Text('취소'), // 취소 버튼 텍스트를 설정 
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('저장'), // 저장 버튼 텍스트를 설정 
            onPressed: () {
              Navigator.of(context).pop(amount);
            },
          ),
        ],
      );
        },
    );

    if (result != null && result != 0.0) {
      setState(() {
        if (_transactions[date] == null) {
          _transactions[date] = [];
        }
        _transactions[date]!.add({
          'type': type,
          'amount': result,
        });
        _saveTransactions(); // 거래 정보를 저장 
      });
    }
  }

  // 달력에 표시될 이벤트 마커를 생성 
  List<Widget> _buildMarkers(List<Map<String, dynamic>> events) {
    List<Widget> markers = [];
    for (var event in events) {
      Color markerColor;
      if (event['type'] == '월급') {
        markerColor = Colors.green; // 월급인 경우 초록색 마커를 생성 
      } else if (event['type'] == '출금') {
        markerColor = Colors.red; // 출금인 경우 빨간색 마커를 생성 
      } else if (event['type'] == '입금') {
        markerColor = Colors.blue; // 입금인 경우 파란색 마커를 생성 
      } else {
        markerColor = Colors.grey; // 그 외의 경우 회색 마커를 생성 
      }
      markers.add(
        Container(
          width: 7.0,
          height: 7.0,
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: markerColor,
          ),
        ),
      );
    }
    return markers;
  }

  // 거래 리스트를 생성 
  Widget _buildTransactionList(DateTime selectedDay) {
    // 선택된 날짜에 해당하는 거래 목록을 가져온다. 만약 해당하는 거래가 없다면 빈 리스트를 사용
    final transactions = _transactions[selectedDay] ?? [];
    return Expanded(
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Container(
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              leading: Icon(
                transaction['type'] == '월급'
                    ? Icons.attach_money
                    : transaction['type'] == '출금'
                    ? Icons.money_off
                    : Icons.account_balance_wallet,
                color: transaction['type'] == '월급'
                    ? Colors.green
                    : transaction['type'] == '출금'
                    ? Colors.red
                    : Colors.blue,
              ),
              title: Text('${transaction['type']} - ${transaction['amount']}원'), // 거래 유형과 금액을 표시 
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red), // 삭제 아이콘을 설정 
                onPressed: () {
                  setState(() {
                    transactions.removeAt(index); // 거래를 삭제 
                    _saveTransactions(); // 거래 정보를 저장 
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // 선택한 달의 총 수입을 계산 
  double _calculateTotalSalary(DateTime focusedDay) {
    double totalSalary = 0.0;
    _transactions.forEach((date, transactions) {
      if (date.year == focusedDay.year && date.month == focusedDay.month) {
        for (var transaction in transactions) {
          if (transaction['type'] == '월급' || transaction['type'] == '입금') {
            totalSalary += transaction['amount'];
          } else if (transaction['type'] == '출금') {
            totalSalary -= transaction['amount'];
          }
        }
      }
    });
    return totalSalary;
  }
}
