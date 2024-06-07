class ToDo {
  String? id;
  String? todoText;
  bool isDone;
  String? category;
  DateTime? deadline;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
    this.category,
    this.deadline,
  });

  static List<ToDo> todoList() {
    return [];
  }
}
