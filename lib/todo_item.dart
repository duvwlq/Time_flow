import 'package:flutter/material.dart';
import 'package:blink_list/model/todo.dart';
import 'package:intl/intl.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final Function(ToDo) onToDoChanged;
  final Function(String) onDeleteItem;

  const ToDoItem({
    Key? key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDeleteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final bool isOverdue = todo.deadline != null && todo.deadline!.isBefore(DateTime.now());

    return Card(
      color: isOverdue ? Colors.red[50] : Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Checkbox(
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
        subtitle: Column(
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
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            onDeleteItem(todo.id!);
          },
        ),
      ),
    );
  }
}
