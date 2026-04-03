import 'package:flutter/foundation.dart';
import '../models/study_task.dart';
import '../services/task_repository.dart';

/// ViewModel to manage state and handle business logic for Tasks,
/// fulfilling the MVVM architecture requirement for Assignment 4.
class TaskViewModel extends ChangeNotifier {
  final TaskRepository _repository;

  List<StudyTask> _tasks = [];
  bool _isLoading = false;

  TaskViewModel(this._repository) {
    loadTasks();
  }

  List<StudyTask> get tasks => _tasks;
  bool get isLoading => _isLoading;

  // Part 5 & 7: State Management & System Feedback (Loading states)
  void loadTasks() {
    _isLoading = true;
    notifyListeners();

    _tasks = _repository.loadTasks();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(StudyTask task) async {
    _isLoading = true;
    notifyListeners();

    await _repository.addTask(task);
    _tasks = _repository.loadTasks(); // Refresh list

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateTask(StudyTask task) async {
    await _repository.updateTask(task);
    _tasks = _repository.loadTasks();
    notifyListeners();
  }

  Future<void> deleteTask(String taskId) async {
    await _repository.deleteTask(taskId);
    _tasks = _repository.loadTasks();
    notifyListeners();
  }
}
