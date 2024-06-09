import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:blink_list/model/todo.dart';
import 'package:blink_list/todo_item.dart';

class CalendarPage extends StatefulWidget {
  final List<ToDo> todosList;
  final Function(ToDo) onToDoChanged;
  final Function(String) onDeleteItem;
  final Color backgroundColor;

  CalendarPage({
    required this.todosList,
    required this.onToDoChanged,
    required this.onDeleteItem,
    required this.backgroundColor,
  });

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1), // 날짜 범위 설정
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay, // 현재 포커스된 날짜
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
            ),
            eventLoader: _getEventsForDay, // 특정 날짜에 할 일이 있는지 확 인
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    bottom: 1,
                    child: _buildEventsMarker(),
                  );
                }
                return Container();
              },
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                for (ToDo todo in _getEventsForDay(_selectedDay ?? _focusedDay))
                  ToDoItem(
                    todo: todo,
                    onToDoChanged: widget.onToDoChanged,
                    onDeleteItem: widget.onDeleteItem,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<ToDo> _getEventsForDay(DateTime day) { // 특정 날짜의 할 일 표시
    return widget.todosList.where((todo) {
      return todo.deadline != null &&
          todo.deadline!.year == day.year &&
          todo.deadline!.month == day.month &&
          todo.deadline!.day == day.day;
    }).toList();
  }

  Widget _buildEventsMarker() { // 할 일이 있는 날 아래에 빨간 점 표시
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
      width: 7.0,
      height: 7.0,
      margin: const EdgeInsets.symmetric(horizontal: 1.5),
    );
  }
}
