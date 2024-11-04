import 'package:flutter/material.dart';
import 'add_task_screen.dart';
import 'package:flutter_task_management_app/task_model.dart';
import 'package:flutter_task_management_app/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  Future<void> _refreshTasks() async {
    tasks = await DatabaseHelper.instance.readAllTasks();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteAllTasks,
          ),
        ],
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No Tasks'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.note),
                  trailing: Checkbox(
                    value: task.isCompleted,
                    onChanged: (bool? value) {
                      _toggleCompletion(task);
                    },
                  ),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AddTaskScreen(task: task),
                      ),
                    );
                    _refreshTasks();
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => AddTaskScreen()));
          _refreshTasks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _toggleCompletion(Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      note: task.note,
      isCompleted: !task.isCompleted,
      time: task.time,
      date: task.date,
    );
    await DatabaseHelper.instance.updateTask(updatedTask);
    _refreshTasks();
  }

  Future<void> _deleteAllTasks() async {
    for (var task in tasks) {
      await DatabaseHelper.instance.deleteTask(task.id!);
    }
    _refreshTasks();
  }
}
