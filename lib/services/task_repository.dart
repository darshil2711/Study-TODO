import 'package:shared_preferences/shared_preferences.dart';

import '../models/study_task.dart';

/// Simple repository that persists tasks into SharedPreferences.
class TaskRepository {
  TaskRepository._(this._prefs);

  static const _tasksKey = 'study_todo_tasks';

  final SharedPreferences _prefs;

  static Future<TaskRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return TaskRepository._(prefs);
  }

  List<StudyTask> loadTasks() {
    final jsonString = _prefs.getString(_tasksKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    return StudyTask.listFromJsonString(jsonString);
  }

  Future<void> saveTasks(List<StudyTask> tasks) async {
    final jsonString = StudyTask.listToJsonString(tasks);
    await _prefs.setString(_tasksKey, jsonString);
  }

  Future<void> addTask(StudyTask task) async {
    final tasks = loadTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  Future<void> updateTask(StudyTask task) async {
    final tasks = loadTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await saveTasks(tasks);
    }
  }

  Future<void> deleteTask(String taskId) async {
    final tasks = loadTasks();
    tasks.removeWhere((t) => t.id == taskId);
    await saveTasks(tasks);
  }
}
