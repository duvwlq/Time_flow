class ToDo {
  String id;
  String todoText;
  bool isDone;
  String category;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
    required this.category,
  });

  static List<ToDo> todoList() {
    return [];
  }
}
