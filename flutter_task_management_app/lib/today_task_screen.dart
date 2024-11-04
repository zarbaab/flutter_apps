import 'package:flutter/material.dart';
import 'package:flutter_task_management_app/db_helper.dart';
import 'package:flutter_task_management_app/task_model.dart';

class TodayTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: DatabaseHelper.instance.readTodayTasks(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.isEmpty) {
          return Center(child: Text('No tasks for today.'));
        }
        return ListView(
          children: snapshot.data!.map((task) => TaskTile(task)).toList(),
        );
      },
    );
  }
}
