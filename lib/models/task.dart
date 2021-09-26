import 'package:intl/intl.dart';
import 'package:todoapp/database/task_helper.dart';

class Task {
  final int? id;
  final String name;
  final int priority;
  final DateTime deadline;
  final String memo;

  const Task({
    this.id,
    required this.name,
    required this.priority,
    required this.deadline,
    required this.memo,
  });

  Task copy({
    int? id,
    String? name,
    int? priority,
    DateTime? deadline,
    String? memo,
  }) =>
      Task(
        id: id ?? this.id,
        name: name ?? this.name,
        priority: priority ?? this.priority,
        deadline: deadline ?? this.deadline,
        memo: memo ?? this.memo,
      );

  static Task fromJson(Map<String, Object?> json) => Task(
        id: json[columnId] as int,
        name: json[columnName] as String,
        priority: json[columnPriority] as int,
        deadline: DateTime.parse(json[columnDeadline] as String),
        memo: json[columnMemo] as String,
      );

  Map<String, Object?> toJson() => {
        columnName: name,
        columnPriority: priority,
        columnDeadline: DateFormat('yyyy-MM-dd HH:mm:ss').format(deadline),
        columnMemo: memo,
      };
}
