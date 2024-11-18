import 'dart:async';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_task_management_app/add_task_screen.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'task_model.dart';
import 'db_helper.dart';

class HomeScreen extends StatefulWidget {
  final void Function() onThemeChange; // Updated to void Function()

  const HomeScreen({super.key, required this.onThemeChange});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool _isDarkMode = false;
  List<Task> tasks = [];
  Timer? _timer;
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _startTaskReminderTimer();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTaskReminderTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      final now = DateTime.now();
      for (final task in tasks) {
        if (task.isRepeated && !task.isCompleted && task.dueDate != null) {
          final remainingTime = _calculateTimeRemaining(task.dueDate);

          if (remainingTime != null) {
            if (!task.isCompleted && remainingTime.isNegative) {
              AwesomeNotifications().createNotification(
                content: NotificationContent(
                  id: task.id ?? 0,
                  channelKey: 'basic_channel',
                  title: task.title,
                  body: "Task time out",
                ),
              );
            } else if (!task.isCompleted && remainingTime.inMinutes <= 30) {
              AwesomeNotifications().createNotification(
                content: NotificationContent(
                  id: task.id ?? 0,
                  channelKey: 'basic_channel',
                  title: task.title,
                  body: "Complete soon!",
                ),
              );
            } else if (task.isRepeated && task.dueDate!.isBefore(now)) {
              AwesomeNotifications().createNotification(
                content: NotificationContent(
                  id: task.id ?? 0,
                  channelKey: 'basic_channel',
                  title: task.title,
                  body: "Task repeat!",
                ),
              );
            }
          }
        }
      }
      setState(() {}); // Update UI with the latest task states
    });
  }

  Future<void> _loadTasks() async {
    tasks = await _databaseHelper.readAllTasks();
    for (var task in tasks) {
      _updateTaskProgress(task);
    }
    setState(() {});
  }

  Duration? _calculateTimeRemaining(DateTime? dueDate) {
    if (dueDate == null) return null;
    return dueDate.difference(DateTime.now());
  }

  void _updateTaskProgress(Task task) {
    if (task.subtasks.isNotEmpty) {
      int completedSubtasks =
          task.subtasks.where((subtask) => subtask.isCompleted).length;
      task.completionPercentage =
          (completedSubtasks / task.subtasks.length) * 100.0;
    } else {
      task.completionPercentage = task.isCompleted ? 100.0 : 0.0;
    }
  }

  Future<void> exportTasksToPDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: tasks.map((task) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Title: ${task.title}",
                      style: pw.TextStyle(fontSize: 18)),
                  pw.Text("Description: ${task.description}"),
                  pw.Text("Due Date: ${task.dueDate?.toString() ?? "N/A"}"),
                  pw.Text("Completed: ${task.isCompleted ? "Yes" : "No"}"),
                  pw.Text("Progress: ${(task.completionPercentage).toInt()}%"),
                  pw.Divider(),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'tasks.pdf');
  }

  void _addTask(Task task) {
    setState(() {
      tasks.add(task);
      _updateTaskProgress(task);
    });
    _databaseHelper.createTask(task);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${task.title} added')));
  }

  void _handleTaskCompletion(Task task) {
    if (task.isCompleted) {
      task.completionPercentage = 100.0;
    } else {
      _updateTaskProgress(task);
    }

    if (task.isRepeated && task.isCompleted) {
      if (task.repeatFrequency == 'daily') {
        task.dueDate = DateTime.now().add(const Duration(days: 1));
      } else if (task.repeatFrequency == 'weekly' && task.repeatDays != null) {
        DateTime nextDate = DateTime.now();
        while (!task.repeatDays!.contains(_getDayName(nextDate))) {
          nextDate = nextDate.add(const Duration(days: 1));
        }
        task.dueDate = nextDate;
      }
      task.isCompleted = false;
      task.completionPercentage = 0.0;
      task.lastCompleted = DateTime.now();
    }

    setState(() {
      _databaseHelper.updateTask(task);
    });
  }

  String _getDayName(DateTime date) {
    return [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ][date.weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Task Management'),
          actions: [
            Switch(
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                  widget.onThemeChange();
                });
              },
              activeColor: Colors.white,
            ),
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: () {
                exportTasksToPDF();
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "Today's Tasks"),
              Tab(text: "Completed Tasks"),
              Tab(text: "Repeated Tasks"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTaskListView((task) =>
                task.dueDate?.day == DateTime.now().day && !task.isCompleted),
            _buildTaskListView((task) => task.isCompleted),
            _buildTaskListView((task) => task.isRepeated),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddTaskScreen(onSave: _addTask)),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildTaskListView(bool Function(Task) filter) {
    final filteredTasks = tasks.where(filter).toList();
    return filteredTasks.isEmpty
        ? const Center(child: Text('No tasks available'))
        : ListView.builder(
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              final task = filteredTasks[index];
              final timeRemaining = _calculateTimeRemaining(task.dueDate);
              return ListTile(
                title: Text(task.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.description),
                    if (timeRemaining != null)
                      Text('Time Remaining: $timeRemaining',
                          style: const TextStyle(color: Colors.red)),
                    LinearProgressIndicator(
                        value: task.completionPercentage / 100),
                    Text(
                        '${task.completionPercentage.toStringAsFixed(0)}% Complete'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        setState(() {
                          task.isCompleted = value ?? false;
                          _handleTaskCompletion(task);
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          tasks.remove(task);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${task.title} removed')));
                        });
                      },
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddTaskScreen(onSave: _addTask)),
                  );
                },
              );
            },
          );
  }
}
