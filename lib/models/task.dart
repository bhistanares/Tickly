class Task {
  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.note,
    required this.isDone,
  });

  final int id;
  String title;
  String category;
  String note;
  bool isDone;
}

class TaskFormResult {
  const TaskFormResult({
    required this.title,
    required this.category,
    required this.note,
  });

  final String title;
  final String category;
  final String note;
}
