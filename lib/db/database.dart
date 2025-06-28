import 'package:hive_flutter/hive_flutter.dart';

class TodoDB {
  List<List<Object?>> toDoList = [];

  final _myBox = Hive.box('mybox');

  void createInitialData() {
    toDoList = [

    ];
  }

  void loadData() {
    toDoList = _myBox.get("TODOLIST")?.cast<List<Object?>>() ?? [];
  }

  void updateDatabase() {
    _myBox.put('TODOLIST', toDoList);
  }
}