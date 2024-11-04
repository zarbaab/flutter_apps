import 'package:flutter/material.dart';
import 'package:flutter_task_management_app/db_helper.dart';
import 'package:flutter_task_management_app/task_model.dart';
class AddTaskScreen extends StatefulWidget {
  final Task? task;

  const AddTaskScreen({Key? key, this.task}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String note;
  late bool isCompleted;
  late String time;
  late String date;

  @override
  void initState() {
    super.initState();
    title = widget.task?.title ?? '';
    note = widget.task?.note ?? '';
    isCompleted = widget.task?.isCompleted ?? false;
    time = widget.task?.time ?? '';
    date = widget.task?.date ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add New Task' : 'Update Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) => title = value!,
              ),
              TextFormField(
                initialValue: note,
                decoration: const InputDecoration(labelText: 'Note'),
                onSaved: (value) => note = value!,
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

  Future<void> _saveTask() async {
    _formKey.currentState!.save();
    final task = Task(
      id: widget.task?.id,
      title: title,
      note: note,
      isCompleted: isCompleted,
      time: time,
      date: date,
    );
    if (widget.task == null) {
      await DatabaseHelper.instance.createTask(task);
    } else {
      await DatabaseHelper.instance.updateTask(task);
    }
    Navigator.of(context).pop();
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

