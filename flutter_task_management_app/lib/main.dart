import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;
import 'welcomepage.dart';

void main() {
  // Initialize database factory for non-mobile platforms (desktop/web)
  if (!Platform.isAndroid && !Platform.isIOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const TaskManagementApp());
}

class TaskManagementApp extends StatefulWidget {
  const TaskManagementApp({super.key});

  @override
  TaskManagementAppState createState() => TaskManagementAppState();
}

class TaskManagementAppState extends State<TaskManagementApp> {
  bool _isDarkTheme = false;

  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Management App',
      theme: _isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: WelcomePage(toggleTheme: _toggleTheme), // Pass toggleTheme
    );
  }
}
