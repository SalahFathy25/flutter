import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/task.dart';

class HiveDataStorage {
  static const boxName = 'tasksBox';

  final Box<Task> box = Hive.box<Task>(boxName);

  Future<void> addTask(Task task) async {
    await box.put(task.id, task);
  }

  Future<void> updateTask(Task task) async {
    await box.put(task.id, task);
  }

  Future<void> deleteTask(Task task) async {
    await task.delete();
  }

  Future<List<Task>> getAllTasks() async {
    return box.values.toList();
  }

  Future<Task?> getTaskById(String id) async {
    return box.get(id)!;
  }

  Future<void> deleteAllTasks() async {
    await box.clear();
  }

  Future<void> updateTaskStatus(Task task) async {
    await task.save();
  }

  Future<void> deleteTaskById(String id) async {
    await box.delete(id);
  }

  ValueListenable<Box<Task>> listenToTask() {
    return box.listenable();
  }
}
