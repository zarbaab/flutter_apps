import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'db_helper.dart';
import 'task_model.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;
  final Function(Task) onSave;

  const AddTaskScreen({super.key, this.task, required this.onSave});

  @override
  AddTaskScreenState createState() => AddTaskScreenState();
}

class AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  List<String> _repeatDays = [];
  List<Subtask> subtasks = [];
  bool _isRepeated = false;
  final bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _dueDate = widget.task?.dueDate;
    _repeatDays = widget.task?.repeatDays ?? [];
    subtasks = widget.task?.subtasks ?? [];
  }

  List<String> _getSelectedDays() {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return [
      for (int i = 0; i < 7; i++)
        if (_repeatDays.contains(days[i])) days[i]
    ];
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final task = Task(
        id: widget.task?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        isCompleted: _isCompleted,
        time: _dueTime != null ? _dueTime!.format(context) : '',
        date:
            _dueDate != null ? DateFormat('yyyy-MM-dd').format(_dueDate!) : '',
        dueDate: _combineDateAndTime(_dueDate, _dueTime),
        repeatDays: _getSelectedDays(),
        subtasks: subtasks,
      );

      try {
        if (widget.task == null) {
          int taskId = await DatabaseHelper.instance.createTask(task);
          for (var subtask in subtasks) {
            await DatabaseHelper.instance.createSubtask(taskId, subtask.title);
          }
        } else {
          await DatabaseHelper.instance.updateTask(task);
          for (var subtask in subtasks) {
            if (subtask.id != null) {
              await DatabaseHelper.instance
                  .updateSubtask(subtask.id!, subtask.isCompleted);
            } else {
              await DatabaseHelper.instance
                  .createSubtask(task.id!, subtask.title);
            }
          }
        }
        widget.onSave(task);
      } catch (e) {
        debugPrint('Error saving task: $e');
      }
    }
  }

  void triggerNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'Task Added successfully',
        body: 'Start working on it now and stay on track!',
      ),
    );
  }

  DateTime? _combineDateAndTime(DateTime? date, TimeOfDay? time) {
    if (date == null || time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add New Task' : 'Update Task'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Title cannot be empty' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value!.isEmpty ? 'Description cannot be empty' : null,
              ),
              Row(
                children: [
                  const Text('Due Date:'),
                  Text(_dueDate != null
                      ? DateFormat('yyyy-MM-dd').format(_dueDate!)
                      : 'Not Set'),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: _dueDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      setState(() {
                        _dueDate = selectedDate;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Due Time:'),
                  Text(
                      _dueTime != null ? _dueTime!.format(context) : 'Not Set'),
                  IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () async {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: _dueTime ?? TimeOfDay.now(),
                      );
                      setState(() {
                        _dueTime = selectedTime;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isRepeated,
                    onChanged: (bool? value) {
                      setState(() {
                        _isRepeated = value ?? false;
                      });
                    },
                  ),
                  const Text('Repeated Task'),
                ],
              ),
              Wrap(
                spacing: 5.0,
                children: List<Widget>.generate(7, (index) {
                  const days = [
                    'Sun',
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat'
                  ];
                  return ChoiceChip(
                    label: Text(days[index]),
                    selected: _repeatDays.contains(days[index]),
                    onSelected: (selected) {
                      setState(() {
                        selected
                            ? _repeatDays.add(days[index])
                            : _repeatDays.remove(days[index]);
                      });
                    },
                  );
                }),
              ),
              const Text('Subtasks:'),
              ...subtasks.map((subtask) => ListTile(
                    title: Text(subtask.title),
                    trailing: Checkbox(
                      value: subtask.isCompleted,
                      onChanged: (value) {
                        setState(() {
                          subtask.isCompleted = value!;
                        });
                      },
                    ),
                  )),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      String subtaskTitle = '';
                      return AlertDialog(
                        title: const Text('Add Subtask'),
                        content: TextField(
                          onChanged: (value) => subtaskTitle = value,
                          decoration: const InputDecoration(
                              hintText: 'Enter subtask title'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                subtasks.add(Subtask(
                                    title: subtaskTitle, isCompleted: false));
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Add Subtask'),
              ),
              ElevatedButton(
                onPressed: () {
                  triggerNotification();
                  _saveTask();
                },
                child: Text(widget.task == null ? 'Add Task' : 'Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
