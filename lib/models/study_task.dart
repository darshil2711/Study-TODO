import 'dart:convert';

/// A simple model representing a study task in Study TO DO.
///
/// This model is stored in local persistent storage as JSON.
class StudyTask {
  StudyTask({
    required this.id,
    required this.title,
    this.description = '',
    this.dueDate,
    this.completed = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Unique identifier for the task.
  final String id;

  /// The title shown in the task list.
  final String title;

  /// Optional longer description.
  final String description;

  /// Optional due date for the task.
  final DateTime? dueDate;

  /// Whether the task is complete.
  bool completed;

  /// Creation timestamp.
  final DateTime createdAt;

  /// Helper to show the due date in a friendly format.
  String get dueDateLabel {
    if (dueDate == null) return 'No deadline';
    return '${dueDate!.year}-${dueDate!.month.toString().padLeft(2, '0')}-${dueDate!.day.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'completed': completed,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory StudyTask.fromJson(Map<String, dynamic> json) {
    return StudyTask(
      id: json['id'] as String,
      title: json['title'] as String,
      description: (json['description'] as String?) ?? '',
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      completed: (json['completed'] as bool?) ?? false,
      createdAt: json['createdAt'] == null
          ? DateTime.now()
          : DateTime.parse(json['createdAt'] as String),
    );
  }

  /// For storage in shared preferences.
  static List<StudyTask> listFromJsonString(String jsonString) {
    final dynamic decoded = jsonDecode(jsonString);
    if (decoded is! List) return <StudyTask>[];
    return decoded
        .cast<Map<String, dynamic>>()
        .map((map) => StudyTask.fromJson(map))
        .toList();
  }

  static String listToJsonString(List<StudyTask> tasks) {
    return jsonEncode(tasks.map((t) => t.toJson()).toList());
  }
}
