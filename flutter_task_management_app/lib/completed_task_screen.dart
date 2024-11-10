import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'task_model.dart';

class CompletedTaskScreen extends StatelessWidget {
  const CompletedTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: DatabaseHelper.instance.readCompletedTasks(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.isEmpty) {
          return const Center(child: Text('No completed tasks.'));
        }
        return ListView(
          children: snapshot.data!
              .map((task) => ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.note),
                  ))
              .toList(),
        );
      },
    );
  }
}
