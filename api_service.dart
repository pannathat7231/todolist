import 'dart:convert';
import 'package:http/http.dart' as http;
import 'task.dart';

class ApiService {
  // URL ของ API ที่ทำงานใน Emulator Android
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  // ฟังก์ชันดึงข้อมูล task ทั้งหมดจาก API
  static Future<List<TodoItem>> fetchTasks() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/tasks'));

      if (response.statusCode == 200) {
        // ถ้าสถานะการตอบกลับเป็น 200 OK
        List<dynamic> data = json.decode(response.body);
        return data.map((task) => TodoItem.fromJson(task)).toList(); // แปลงข้อมูล JSON ไปเป็น List<TodoItem>
      } else {
        // แสดงข้อความ error ที่ได้รับจาก API
        print('Error fetching tasks: ${response.body}');
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
      throw Exception('Failed to fetch tasks: $e');
    }
  }

  // ฟังก์ชันสร้าง task ใหม่
  static Future<void> createTask(TodoItem task) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tasks'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(task.toJson()),
      );

      print('Response: ${response.body}'); // เพิ่ม print เพื่อดูการตอบกลับจาก server

      if (response.statusCode != 201) {
        print('Error creating task: ${response.body}');
        throw Exception('Failed to create task');
      }
    } catch (e) {
      print('Error creating task: $e');
      throw Exception('Failed to create task: $e');
    }
  }

  // ฟังก์ชันอัปเดต task
  static Future<void> updateTask(TodoItem task) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/tasks/${task.id}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(task.toJson()),
      );

      print('Response: ${response.body}'); // เพิ่ม print เพื่อดูการตอบกลับจาก server

      if (response.statusCode != 200) {
        print('Error updating task: ${response.body}');
        throw Exception('Failed to update task');
      }
    } catch (e) {
      print('Error updating task: $e');
      throw Exception('Failed to update task: $e');
    }
  }

  // ฟังก์ชันลบ task
  static Future<void> deleteTask(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/tasks/$id'),
      );

      print('Response: ${response.body}'); // เพิ่ม print เพื่อดูการตอบกลับจาก server

      if (response.statusCode != 200) {
        print('Error deleting task: ${response.body}');
        throw Exception('Failed to delete task');
      }
    } catch (e) {
      print('Error deleting task: $e');
      throw Exception('Failed to delete task: $e');
    }
  }
}
