class Task {
  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.note,
    required this.isDone,
    this.deadline,
  });

  final int id;
  String title;
  String category;
  String note;
  bool isDone;
  DateTime? deadline;
}

class TaskFormResult {
  const TaskFormResult({
    required this.title,
    required this.category,
    required this.note,
    this.deadline,
  });

  final String title;
  final String category;
  final String note;
  final DateTime? deadline;
}
