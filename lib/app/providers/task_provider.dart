// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../data/hive_data_storage.dart';
import '../model/task.dart';

class TaskProvider with ChangeNotifier {
  Task? task;
  final HiveDataStorage hiveDataStorage;
  TextEditingController? titleController;
  TextEditingController? subtitleController;

  TaskProvider(this.hiveDataStorage) {
    titleController = TextEditingController();
    subtitleController = TextEditingController();
    loadPreferences();
  }

  DateTime? time;
  DateTime? date;

  List<Task> _tasks = [];
  List<String> tasksJson = sharedPreferences.getStringList('tasks') ?? [];
  String? _error;
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  String? get error => _error;
  bool get isLoading => _isLoading;

  void initializeTask(Task task) {
    this.task = task;
    titleController?.text = task.title;
    subtitleController?.text = task.subtitle;
    date = task.date;
    time = task.time;
    notifyListeners();
  }

  Future<void> loadPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadTasks();
  }

  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      List<String> tasksJson = sharedPreferences.getStringList('tasks') ?? [];
      _tasks = tasksJson.map((taskJson) {
        return Task.fromJson(jsonDecode(taskJson));
      }).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setTime(DateTime selectedTime) {
    final now = DateTime.now();
    time = DateTime(
        now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);
    notifyListeners();
  }

  String showTime(DateTime? selectedTime) {
    return DateFormat('hh:mm a').format(selectedTime ?? DateTime.now());
  }

  void setDate(DateTime selectedDate) {
    date = selectedDate;
    notifyListeners();
  }

  String showDate(DateTime? selectedDate) {
    return DateFormat.yMMMEd().format(selectedDate ?? DateTime.now());
  }

  Future<void> addTask(BuildContext context) async {
    if (titleController!.text.isNotEmpty &&
        subtitleController!.text.isNotEmpty) {
      final newTask = Task.create(
        title: titleController!.text,
        subtitle: subtitleController!.text,
        time: time,
        date: date,
      );

      List<String> tasksJson = sharedPreferences.getStringList('tasks') ?? [];
      tasksJson.add(jsonEncode(newTask.toJson()));
      await sharedPreferences.setStringList('tasks', tasksJson);
      hiveDataStorage.addTask(newTask);

      await loadTasks();
      Navigator.pop(context);
    } else {
      showEmptyFieldsWarning(context);
      _error = 'All fields are required!';
      notifyListeners();
    }
  }

  Future<void> updateTask(BuildContext context, Task task) async {
    if (titleController!.text.isNotEmpty &&
        subtitleController!.text.isNotEmpty) {
      final updatedTask = Task(
        id: task.id,
        title: titleController!.text,
        subtitle: subtitleController!.text,
        time: time!,
        date: date!,
        status: task.status,
      );

      List<String> tasksJson = sharedPreferences.getStringList('tasks') ?? [];
      tasksJson = tasksJson.map((taskJson) {
        Task oldTask = Task.fromJson(jsonDecode(taskJson));
        return oldTask.id == updatedTask.id
            ? jsonEncode(updatedTask.toJson())
            : taskJson;
      }).toList();

      await sharedPreferences.setStringList('tasks', tasksJson);
      hiveDataStorage.updateTask(updatedTask);

      await loadTasks();
      Navigator.pop(context);
    } else {
      showEmptyFieldsWarning(context);
      _error = 'All fields are required!';
      notifyListeners();
    }
  }

  void updateSubtitle(String subtitle) {
    subtitleController!.text = subtitle;
    notifyListeners();
  }

  Future<void> deleteTask(Task task) async {
    List<String> tasksJson = sharedPreferences.getStringList('tasks') ?? [];
    tasksJson.removeWhere(
        (taskJson) => Task.fromJson(jsonDecode(taskJson)).id == task.id);

    await sharedPreferences.setStringList('tasks', tasksJson);
    hiveDataStorage.deleteTask(task);

    await loadTasks();
  }

  bool hasTaskChanged(Task task) {
    return task.title != titleController!.text ||
        task.subtitle != subtitleController!.text;
  }

  void showEmptyFieldsWarning(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill all fields!')),
    );
  }
}
