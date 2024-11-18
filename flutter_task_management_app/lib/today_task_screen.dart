import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'task_model.dart';

class TodayTaskScreen extends StatelessWidget {
  const TodayTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: DatabaseHelper.instance.readTodayTasks(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.isEmpty) {
          return const Center(child: Text('No tasks for today.'));
        }
        return ListView(
          children: snapshot.data!
              .map((task) => ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.description),
                  ))
              .toList(),
        );
      },
    );
  }
}
