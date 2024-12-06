import 'package:flutter/material.dart';
import '../data/hive_data_storage.dart';
import '../model/task.dart';

class HomeProvider with ChangeNotifier {
  final HiveDataStorage hiveDataStorage;

  HomeProvider(this.hiveDataStorage);

  List<Task> _tasks = [];
  String? _error;
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  String? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final tasks = await hiveDataStorage.getAllTasks();
      tasks.sort((a, b) => b.time.compareTo(a.time));
      tasks.sort((a, b) => b.date.compareTo(a.date));
      _tasks = tasks;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAllTasks() async {
    try {
      await hiveDataStorage.deleteAllTasks();
      _tasks = [];
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteTask(Task task) async {
    try {
      await hiveDataStorage.deleteTask(task);
      await loadTasks();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleTaskStatus(Task task) async {
    try {
      task.status = !task.status;
      await hiveDataStorage.updateTask(task);
      await loadTasks();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
