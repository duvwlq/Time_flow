import 'package:flutter/material.dart';
import 'package:blink_list/model/todo.dart';
import 'package:intl/intl.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo; // 할 일 항목
  final Function(ToDo) onToDoChanged; // 할 일 상태 변경 함수
  final Function(String) onDeleteItem; // 할 일 삭제 함수

  const ToDoItem({
    Key? key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDeleteItem,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final bool isOverdue = todo.deadline != null && todo.deadline!.isBefore(DateTime.now()); // 할 일의 마감기한이 지났는지를 나타내는 변수

    return Card(
      color: isOverdue ? Colors.red[50] : Colors.white, // 마감기한이 지난 경우 빨간색 표시
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Checkbox( // 할 일의 완료 여부 확인
          value: todo.isDone,
          onChanged: (bool? value) {
            onToDoChanged(todo);
          },
        ),
        title: Text(
          todo.todoText ?? '',
          style: TextStyle(
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
            color: isOverdue ? Colors.red : null,
          ),
        ),
        subtitle: Column( // 마감기한 표시
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(todo.category ?? ''),
            if (todo.deadline != null)
              Text(
                'Deadline: ${dateFormat.format(todo.deadline!)}',
                style: TextStyle(
                  color: isOverdue ? Colors.red : null,
                ),
              ),
          ],
        ),
        trailing: IconButton( // 할 일의 삭제 아이콘
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            onDeleteItem(todo.id!);
          },
        ),
      ),
    );
  }
}
