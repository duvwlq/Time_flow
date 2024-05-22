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
  late Map<DateTime, List<Map<String, dynamic>>> _transactions;
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _transactions = {};
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _loadTransactions();
  }

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
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: Text('월급 계산 달력'),
        backgroundColor: Colors.deepPurple[50],
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'ko_KR',
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
            ),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _showInputDialog(selectedDay);
            },
            eventLoader: (day) {
              return _transactions[day] ?? [];
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
                  '내가 번 돈: ${_calculateTotalSalary(_focusedDay).toInt()}원',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 20),
                _buildTransactionList(_selectedDay),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showInputDialog(DateTime date) async {
    double amount = 0.0;
    String type = '월급';
    double? result = await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('거래 입력'),
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
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('저장'),
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
        _saveTransactions();
      });
    }
  }

  List<Widget> _buildMarkers(List<Map<String, dynamic>> events) {
    List<Widget> markers = [];
    for (var event in events) {
      Color markerColor;
      if (event['type'] == '월급') {
        markerColor = Colors.green;
      } else if (event['type'] == '출금') {
        markerColor = Colors.red;
      } else if (event['type'] == '입금') {
        markerColor = Colors.blue;
      } else {
        markerColor = Colors.grey;
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

  Widget _buildTransactionList(DateTime selectedDay) {
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
              title: Text('${transaction['type']} - ${transaction['amount']}원'),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    transactions.removeAt(index);
                    _saveTransactions();
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
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
