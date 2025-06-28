import 'package:flutter/material.dart';
import 'package:todo_app/db/database.dart';
import 'package:hive_flutter/hive_flutter.dart';
class TodoProvider extends ChangeNotifier {
  final TodoDB _db = TodoDB();
  String _sortBy = 'creationDate';

  List<List<Object?>> get toDoList => _db.toDoList;
  String get sortBy => _sortBy;

  void init() {
    if (_db.toDoList.isEmpty) {
      _db.createInitialData();
      _db.updateDatabase();
    } else {
      _db.loadData();
    }
    notifyListeners();
  }

  void checkBoxChanged(int index) {
    _db.toDoList[index][1] = !(_db.toDoList[index][1] as bool);
    _db.updateDatabase();
    notifyListeners();
  }

  void addTask(String taskName, DateTime? dueDate) {
    _db.toDoList.add([taskName, false, DateTime.now(), dueDate]);
    _db.updateDatabase();
    notifyListeners();
  }

  void editTask(int index, String taskName, DateTime? dueDate) {
    _db.toDoList[index][0] = taskName;
    _db.toDoList[index][3] = dueDate;
    _db.updateDatabase();
    notifyListeners();
  }

  void deleteTask(int index) {
    _db.toDoList.removeAt(index);
    _db.updateDatabase();
    notifyListeners();
  }

  void sortTasks(String? sortBy) {
    if (sortBy == null) return;
    _sortBy = sortBy;
    if (sortBy == 'creationDate') {
      _db.toDoList.sort((a, b) => (a[2] as DateTime).compareTo(b[2] as DateTime));
    } else if (sortBy == 'dueDate') {
      _db.toDoList.sort((a, b) {
        final aDue = a[3] as DateTime?;
        final bDue = b[3] as DateTime?;
        if (aDue == null && bDue == null) return 0;
        if (aDue == null) return 1;
        if (bDue == null) return -1;
        return aDue.compareTo(bDue);
      });
    }
    _db.updateDatabase();
    notifyListeners();
  }
}