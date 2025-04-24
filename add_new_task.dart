import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'task.dart';

class AddNewTask extends StatefulWidget {
  @override
  _AddNewTaskState createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDueDate;
  final FocusNode _focusNode = FocusNode(); // เพิ่ม FocusNode

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // TextField สำหรับพิมพ์ชื่อ task ใหม่
          TextField(
            controller: _controller,
            focusNode: _focusNode,  // เชื่อมกับ FocusNode
            decoration: InputDecoration(labelText: 'New Task'),
            keyboardType: TextInputType.text, // ใช้คีย์บอร์ดข้อความ
            autofocus: true,  // เปิดการใช้คีย์บอร์ดเมื่อเข้า TextField
          ),
          Row(
            children: [
              Text(
                _selectedDueDate == null
                    ? 'ยังไม่ได้ตั้งเวลา'
                    : 'จะเสร็จภายใน: ${DateFormat('yyyy-MM-dd HH:mm').format(_selectedDueDate!)}',
              ),
              Spacer(),
              TextButton(
                child: Text('ตั้งเวลา'),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );

                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (time != null) {
                      final dueDate = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );

                      setState(() {
                        _selectedDueDate = dueDate;
                      });
                    }
                  }
                },
              ),
            ],
          ),
          // ปุ่มเพิ่ม task ใหม่
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                String timestamp = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

                // สร้าง TodoItem ใหม่
                TodoItem newTask = TodoItem(
                  title: _controller.text,
                  timestamp: timestamp,
                  dueDate: _selectedDueDate,
                );

                // เพิ่ม task ใหม่ใน provider
                provider.addTask(newTask);

                // ล้างค่า TextField หลังจากเพิ่ม task
                _controller.clear();
                setState(() => _selectedDueDate = null); // รีเซ็ตเวลา
                _focusNode.requestFocus(); // ตั้ง focus ให้ TextField ใหม่
              }
            },
          ),
        ],
      ),
    );
  }
}
