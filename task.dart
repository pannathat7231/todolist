// version database
/* import 'package:flutter/material.dart';
import 'api_service.dart';

class TodoItem {
  String id;
  String title;
  bool isCompleted;
  String timestamp;
  DateTime? dueDate;

  TodoItem({
    this.id = '',
    required this.title,
    this.isCompleted = false,
    required this.timestamp,
    this.dueDate,
  });

  bool isOverdue() {
    if (dueDate == null) return false;
    return DateTime.now().isAfter(dueDate!) && !isCompleted;
  }

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['_id'] ?? '',
      title: json['title'],
      isCompleted: json['isCompleted'],
      timestamp: json['timestamp'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'timestamp': timestamp,
      'dueDate': dueDate?.toIso8601String(),
    };
  }
}

class TodoProvider extends ChangeNotifier {
  List<TodoItem> tasks = [];

  Future<void> loadTasks() async {
    try {
      tasks = await ApiService.fetchTasks();
      _sortTasks();
      notifyListeners();
    } catch (e) {
      print("Error loading tasks: $e");
    }
  }

  Future<void> addTask(TodoItem task) async {
    try {
      await ApiService.createTask(task);
      await loadTasks();
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  Future<void> editTask(int index, String newTitle) async {
    tasks[index].title = newTitle;
    try {
      await ApiService.updateTask(tasks[index]);
      notifyListeners();
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  Future<void> toggleTask(int index) async {
    tasks[index].isCompleted = !tasks[index].isCompleted;
    try {
      await ApiService.updateTask(tasks[index]);
      await loadTasks(); // โหลดใหม่เพื่ออัปเดต UI ทั้ง 2 tab
    } catch (e) {
      print("Error toggling task status: $e");
    }
  }

  Future<void> removeTask(int index) async {
    try {
      await ApiService.deleteTask(tasks[index].id);
      tasks.removeAt(index);
      notifyListeners();
    } catch (e) {
      print("Error removing task: $e");
    }
  }

  void _sortTasks() {
    tasks.sort((a, b) {
      final aDate = a.dueDate ?? DateTime(2100);
      final bDate = b.dueDate ?? DateTime(2100);
      return aDate.compareTo(bDate);
    });
  }
} */


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


import 'package:flutter/material.dart';

class TodoItem {
  String id;
  String title;
  bool isCompleted;
  String timestamp;
  DateTime? dueDate;

  TodoItem({
    this.id = '',
    required this.title,
    this.isCompleted = false,
    required this.timestamp,
    this.dueDate,
  });

  bool isOverdue() {
    if (dueDate == null) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['_id'] ?? '',
      title: json['title'],
      isCompleted: json['isCompleted'],
      timestamp: json['timestamp'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'timestamp': timestamp,
      'dueDate': dueDate?.toIso8601String(),
    };
  }
}

class TodoProvider extends ChangeNotifier {
  List<TodoItem> tasks = [];

  void setTasks(List<TodoItem> newTasks) {
    tasks = newTasks;
    notifyListeners();
  }

  void addTask(TodoItem task) {
    tasks.add(task);
    notifyListeners();
  }

  void editTask(int index, String newTitle) {
    tasks[index].title = newTitle;
    notifyListeners();
  }

  void toggleTask(int index) {
    tasks[index].isCompleted = !tasks[index].isCompleted;
    notifyListeners();
  }

  void removeTask(int index) {
    tasks.removeAt(index);
    notifyListeners();
  }
}