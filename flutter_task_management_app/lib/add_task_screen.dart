import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'task_model.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;
  const AddTaskScreen({Key? key, this.task}) : super(key: key);

  @override
  AddTaskScreenState createState() => AddTaskScreenState();
}

class AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String note = '';
  bool isCompleted = false;
  String time = '';
  String date = '';
  List<bool> _selectedDays = List.generate(7, (_) => false);
  List<Subtask> subtasks = []; // Store subtasks for this task

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      title = widget.task!.title;
      note = widget.task!.note;
      isCompleted = widget.task!.isCompleted;
      time = widget.task!.time;
      date = widget.task!.date;
      subtasks = widget.task!.subtasks; // Load existing subtasks
      if (widget.task!.repeatDays.isNotEmpty) {
        _initializeSelectedDays(widget.task!.repeatDays);
      }
    }
  }

  void _initializeSelectedDays(List<String> repeatDays) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    for (int i = 0; i < days.length; i++) {
      if (repeatDays.contains(days[i])) {
        _selectedDays[i] = true;
      }
    }
  }

  List<String> _getSelectedDays() {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return [
      for (int i = 0; i < 7; i++)
        if (_selectedDays[i]) days[i]
    ];
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final task = Task(
        id: widget.task?.id,
        title: title,
        note: note,
        isCompleted: isCompleted,
        time: time,
        date: date,
        repeatDays: _getSelectedDays(),
        subtasks: subtasks, // Save subtasks with the task
      );

      try {
        if (widget.task == null) {
          int taskId = await DatabaseHelper.instance.createTask(task);
          for (var subtask in subtasks) {
            await DatabaseHelper.instance.createSubtask(taskId, subtask.title);
          }
          debugPrint('Task created successfully');
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
          debugPrint('Task updated successfully');
        }
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        debugPrint('Error saving task: $e');
      }
    }
  }

  void _addSubtask() {
    showDialog(
      context: context,
      builder: (context) {
        String subtaskTitle = '';
        return AlertDialog(
          title: Text('Add Subtask'),
          content: TextField(
            onChanged: (value) => subtaskTitle = value,
            decoration: InputDecoration(hintText: 'Enter subtask title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (subtaskTitle.isNotEmpty) {
                  setState(() {
                    subtasks
                        .add(Subtask(title: subtaskTitle, isCompleted: false));
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        time = pickedTime.format(context);
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        date = '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                initialValue: title,
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (value) => setState(() => title = value),
                validator: (value) =>
                    value!.isEmpty ? 'Title cannot be empty' : null,
              ),
              TextFormField(
                initialValue: note,
                decoration: const InputDecoration(labelText: 'Note'),
                onChanged: (value) => setState(() => note = value),
                validator: (value) =>
                    value!.isEmpty ? 'Note cannot be empty' : null,
              ),
              Row(
                children: [
                  const Text('Time: '),
                  Text(time.isNotEmpty ? time : 'Select'),
                  IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: _selectTime,
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Date: '),
                  Text(date.isNotEmpty ? date : 'Select'),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                ],
              ),
              const Text('Repeat on:'),
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
                    selected: _selectedDays[index],
                    onSelected: (selected) {
                      setState(() {
                        _selectedDays[index] = selected;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),
              // Subtasks Section
              const Text('Subtasks:'),
              ...subtasks.map((subtask) {
                return ListTile(
                  title: Text(subtask.title),
                  trailing: Checkbox(
                    value: subtask.isCompleted,
                    onChanged: (value) {
                      setState(() {
                        subtask.isCompleted = value!;
                      });
                    },
                  ),
                );
              }).toList(),
              TextButton(
                onPressed: _addSubtask,
                child: const Text('Add Subtask'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTask,
                child: Text(widget.task == null ? 'Add Task' : 'Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
