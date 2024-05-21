import 'package:hive_flutter/adapters.dart';

class ToDoDatabase {
  List toDoList = [];

  // 引用 box
  final _myBox = Hive.box('mybox');

  // 初始化的方法
  void createInitialData() {
    toDoList = [
      ['Make Tutorial', false],
      ['Do Exercise', false],
    ];
  }

  // 加载数据
  void loadData() {
    toDoList = _myBox.get('TODOLIST');
  }

  // 更新数据
  void updateDataBase() {
    _myBox.put('TODOLIST', toDoList);
  }
}
