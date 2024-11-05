import 'package:flutter/material.dart';
import 'add_task_screen.dart';
import 'task_model.dart';
import 'db_helper.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const HomeScreen({super.key, required this.toggleTheme});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Task> tasks = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  Future<void> _refreshTasks() async {
    tasks = await DatabaseHelper.instance.readAllTasks();
    setState(() {}); // Updates the UI with the new list of tasks
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: _buildTaskList(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done),
            label: 'Completed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.repeat),
            label: 'Repeated',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? taskAdded = await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
          if (taskAdded == true) {
            _refreshTasks();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList() {
    if (tasks.isEmpty) {
      return const Center(child: Text('No tasks available.'));
    }
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.note),
              if (task.repeatDays.isNotEmpty) // Display repeat days if set
                Text("Repeats on: ${task.repeatDays.join(', ')}"),
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              task.isCompleted
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
            ),
            onPressed: () {
              _toggleCompletion(task);
            },
          ),
          onTap: () async {
            bool? taskUpdated = await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => AddTaskScreen(task: task)),
            );
            if (taskUpdated == true) {
              _refreshTasks();
            }
          },
          onLongPress: () => _showTaskOptions(context, task),
        );
      },
    );
  }

  void _showTaskOptions(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Update Task'),
              onTap: () async {
                Navigator.of(context).pop(); // Close the bottom sheet
                bool? taskUpdated = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => AddTaskScreen(task: task)),
                );
                if (taskUpdated == true) {
                  _refreshTasks();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Task'),
              onTap: () async {
                Navigator.of(context).pop(); // Close the bottom sheet
                _deleteTask(task);
              },
            ),
          ],
        );
      },
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
      repeatDays: task.repeatDays, // Keep repeatDays unchanged
    );
    await DatabaseHelper.instance.updateTask(updatedTask);
    _refreshTasks();
  }

  Future<void> _deleteTask(Task task) async {
    bool shouldDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Task"),
          content:
              Text("Are you sure you want to delete the task '${task.title}'?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );

    if (shouldDelete) {
      await DatabaseHelper.instance.deleteTask(task.id!);
      _refreshTasks();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task deleted successfully")),
      );
    }
  }
}
