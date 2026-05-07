import 'package:flutter/widgets.dart';

class Task {
  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.note,
    required this.isDone,
    this.isPinned = false,
    this.deadline,
    this.completedAt,
  });

  final int id;
  String title;
  String category;
  String note;
  bool isDone;
  bool isPinned;
  DateTime? deadline;
  DateTime? completedAt;
}

class TaskFormResult {
  const TaskFormResult({
    required this.title,
    required this.category,
    required this.categoryIcon,
    required this.note,
    this.deadline,
  });

  final String title;
  final String category;
  final IconData categoryIcon;
  final String note;
  final DateTime? deadline;
}
