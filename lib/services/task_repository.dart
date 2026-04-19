import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/study_task.dart';
import '../logger.dart';

/// Part 3: Secure repository that persists tasks into Encrypted Storage.
class TaskRepository {
  TaskRepository._(this._secureStorage);

  static const _tasksKey = 'study_todo_tasks_secure';

  final FlutterSecureStorage _secureStorage;

  static Future<TaskRepository> create() async {
    const secureStorage = FlutterSecureStorage();
    return TaskRepository._(secureStorage);
  }

  Future<List<StudyTask>> loadTasks() async {
    try {
      final jsonString = await _secureStorage.read(key: _tasksKey);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      AppLogger.debug('Tasks loaded successfully from secure storage');
      return StudyTask.listFromJsonString(jsonString);
    } catch (e, stack) {
      AppLogger.error('Failed to load tasks from secure storage', e, stack);
      return [];
    }
  }

  Future<void> saveTasks(List<StudyTask> tasks) async {
    try {
      final jsonString = StudyTask.listToJsonString(tasks);
      await _secureStorage.write(key: _tasksKey, value: jsonString);
      AppLogger.debug('Tasks saved securely');
    } catch (e, stack) {
      AppLogger.error('Failed to save tasks to secure storage', e, stack);
    }
  }

  Future<void> addTask(StudyTask task) async {
    final tasks = await loadTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  Future<void> updateTask(StudyTask task) async {
    final tasks = await loadTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await saveTasks(tasks);
    }
  }

  Future<void> deleteTask(String taskId) async {
    final tasks = await loadTasks();
    tasks.removeWhere((t) => t.id == taskId);
    await saveTasks(tasks);
  }
}
