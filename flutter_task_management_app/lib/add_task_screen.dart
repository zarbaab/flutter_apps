import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'task_model.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;
  const AddTaskScreen({Key? key, this.task}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String note = '';
  bool isCompleted = false;
  String time = '';
  String date = '';
  List<bool> _selectedDays = List.generate(7, (_) => false);

  @override
  void initState() {
    super.initState();
    title = widget.task?.title ?? '';
    note = widget.task?.note ?? '';
    isCompleted = widget.task?.isCompleted ?? false;
    time = widget.task?.time ?? '';
    date = widget.task?.date ?? '';
    if (widget.task != null && widget.task!.repeatDays.isNotEmpty) {
      _initializeSelectedDays(widget.task!.repeatDays);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Allow the screen to resize when keyboard is open
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add New Task' : 'Update Task'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              const SizedBox(height: 20),
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
              ElevatedButton(
                onPressed: _saveTask, // Removed _isFormFilled check for testing
                child: Text(widget.task == null ? 'Add Task' : 'Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      print(
          "Title: $title, Note: $note, Time: $time, Date: $date, RepeatDays: ${_getSelectedDays()}");

      final task = Task(
        id: widget.task?.id,
        title: title,
        note: note,
        isCompleted: isCompleted,
        time: time,
        date: date,
        repeatDays: _getSelectedDays(),
      );

      if (widget.task == null) {
        await DatabaseHelper.instance.createTask(task);
      } else {
        await DatabaseHelper.instance.updateTask(task);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
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
}
