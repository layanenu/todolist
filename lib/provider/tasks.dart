import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todolist/data/tasks.dart';
import 'package:todolist/models/task.dart';

class Tasks with ChangeNotifier {
  final Map<String, Task> _items = {...TASKS};

  List<Task> get all {
    return [..._items.values];
  }

  int get count {
    return _items.length;
  }

  Task byIndex(int i) {
    return _items.values.elementAt(i);
  }

  void put(Task task) {
    if (task == null) {
      return;
    }

    if (task.id != null &&
        task.id.trim().isNotEmpty &&
        _items.containsKey(task.id)) {
      _items.update(
        task.id,
        (_) => Task(
          id: task.id,
          name: task.name,
          createdAt: task.createdAt,
          location: task.location,
        ),
      );
    } else {
      final id = Random().nextDouble().toString();
      _items.putIfAbsent(
        id,
        () => Task(
          id: id,
          name: task.name,
          createdAt: DateTime.now(),
          location: task.location,
        ),
      );
    }
    notifyListeners();
  }

  void remove(Task task) {
    if (task.id != null && task.id != null) {
      _items.remove(task.id);
      notifyListeners();
    }
  }
}