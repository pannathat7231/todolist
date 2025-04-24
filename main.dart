// version database
/* import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task.dart';
import 'add_new_task.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoProvider()..loadTasks(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TodoScreen(),
      ),
    );
  }
}

class TodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);
    final uncompletedTasks = provider.tasks.where((task) => !task.isCompleted).toList();
    final completedTasks = provider.tasks.where((task) => task.isCompleted).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('To-Do List'),
          bottom: TabBar(
            tabs: [
              Tab(text: '📝 ยังไม่เสร็จ'),
              Tab(text: '✅ สำเร็จแล้ว'),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
            ),
          ],
        ),
        body: Column(
          children: [
            AddNewTask(), // ส่วนกรอกเพิ่ม task
            Expanded(
              child: TabBarView(
                children: [
                  TaskListView(tasks: uncompletedTasks, provider: provider),
                  TaskListView(tasks: completedTasks, provider: provider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskListView extends StatelessWidget {
  final List<TodoItem> tasks;
  final TodoProvider provider;

  TaskListView({required this.tasks, required this.provider});

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? Center(child: Text('ไม่มีงานในรายการนี้'))
        : ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final realIndex = provider.tasks.indexOf(task);

              return ListTile(
                title: GestureDetector(
                  onTap: () {
                    final editController = TextEditingController(text: task.title);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Edit Task'),
                        content: TextField(
                          controller: editController,
                          decoration: InputDecoration(hintText: 'Task Name'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              provider.editTask(realIndex, editController.text);
                              Navigator.pop(context);
                            },
                            child: Text('Save'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          color: task.isCompleted
                              ? Colors.green[800]
                              : (task.isOverdue() ? Colors.red : null),
                        ),
                      ),
                      Text(
                        'สร้างเมื่อ: ${task.timestamp}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      if (task.dueDate != null)
                        Text(
                          'ต้องเสร็จภายใน: ${DateFormat('yyyy-MM-dd HH:mm').format(task.dueDate!)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: task.isCompleted
                                ? Colors.green[800]
                                : (task.isOverdue() ? Colors.red : Colors.orange),
                          ),
                        ),
                    ],
                  ),
                ),
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (_) => provider.toggleTask(realIndex),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        final editController = TextEditingController(text: task.title);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Edit Task'),
                            content: TextField(
                              controller: editController,
                              decoration: InputDecoration(hintText: 'Task Name'),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  provider.editTask(realIndex, editController.text);
                                  Navigator.pop(context);
                                },
                                child: Text('Save'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => provider.removeTask(realIndex),
                    ),
                  ],
                ),
              );
            },
          );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);
    final suggestionList = query.isEmpty
        ? provider.tasks
        : provider.tasks
            .where((task) => task.title.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final task = suggestionList[index];
        return ListTile(
          title: Text(
            task.title + (task.isCompleted ? " ✅" : ""),
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              color: task.isCompleted
                  ? Colors.green[800]
                  : (task.isOverdue() ? Colors.red : null),
            ),
          ),
          subtitle: task.dueDate != null
              ? Text(
                  'ต้องเสร็จภายใน: ${DateFormat('yyyy-MM-dd HH:mm').format(task.dueDate!)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: task.isCompleted
                        ? Colors.green[800]
                        : (task.isOverdue() ? Colors.red : Colors.orange),
                  ),
                )
              : null,
          onTap: () {
            query = task.title;
            showResults(context);
          },
        );
      },
    );
  }
} */


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task.dart';
import 'add_new_task.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TodoScreen(),
      ),
    );
  }
}

class TodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);
    final uncompletedTasks = provider.tasks.where((task) => !task.isCompleted).toList();
    final completedTasks = provider.tasks.where((task) => task.isCompleted).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('To-Do List'),
          bottom: TabBar(
            tabs: [
              Tab(text: '📝 ยังไม่เสร็จ'),
              Tab(text: '✅ สำเร็จแล้ว'),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
            ),
          ],
        ),
        body: Column(
          children: [
            AddNewTask(),
            Expanded(
              child: TabBarView(
                children: [
                  TaskListView(tasks: uncompletedTasks, provider: provider),
                  TaskListView(tasks: completedTasks, provider: provider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskListView extends StatelessWidget {
  final List<TodoItem> tasks;
  final TodoProvider provider;

  TaskListView({required this.tasks, required this.provider});

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? Center(child: Text('ไม่มีงานในรายการนี้'))
        : ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final realIndex = provider.tasks.indexOf(task);

              return ListTile(
                title: GestureDetector(
                  onTap: () {
                    TextEditingController editController = TextEditingController(text: task.title);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Edit Task'),
                        content: TextField(
                          controller: editController,
                          decoration: InputDecoration(hintText: 'Task Name'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              provider.editTask(realIndex, editController.text);
                              Navigator.pop(context);
                            },
                            child: Text('Save'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          color: task.isCompleted
                              ? Colors.green[800]
                              : (task.isOverdue() ? Colors.red : null),
                        ),
                      ),
                      Text(
                        'สร้างเมื่อ: ${task.timestamp}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      if (task.dueDate != null)
                        Text(
                          'ต้องเสร็จภายใน: ${DateFormat('yyyy-MM-dd HH:mm').format(task.dueDate!)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: task.isCompleted
                                ? Colors.green[800]
                                : (task.isOverdue() ? Colors.red : Colors.orange),
                          ),
                        ),
                    ],
                  ),
                ),
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (_) {
                    provider.toggleTask(realIndex);
                  },
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        TextEditingController editController = TextEditingController(text: task.title);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Edit Task'),
                            content: TextField(
                              controller: editController,
                              decoration: InputDecoration(hintText: 'Task Name'),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  provider.editTask(realIndex, editController.text);
                                  Navigator.pop(context);
                                },
                                child: Text('Save'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => provider.removeTask(realIndex),
                    ),
                  ],
                ),
              );
            },
          );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);
    final suggestionList = query.isEmpty
        ? provider.tasks
        : provider.tasks
            .where((task) => task.title.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final task = suggestionList[index];
        return ListTile(
          title: Text(
            task.title + (task.isCompleted ? " ✅" : ""),
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              color: task.isCompleted
                  ? Colors.green[800]
                  : (task.isOverdue() ? Colors.red : null),
            ),
          ),
          subtitle: task.dueDate != null
              ? Text(
                  'ต้องเสร็จภายใน: ${DateFormat('yyyy-MM-dd HH:mm').format(task.dueDate!)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: task.isCompleted
                        ? Colors.green[800]
                        : (task.isOverdue() ? Colors.red : Colors.orange),
                  ),
                )
              : null,
          onTap: () {
            query = task.title;
            showResults(context);
          },
        );
      },
    );
  }
}
