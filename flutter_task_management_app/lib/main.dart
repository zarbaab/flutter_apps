import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;
import 'welcomepage.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('MyAppLogger'); // Logger instance

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Awesome Notifications with notification channel
  AwesomeNotifications().initialize(
    'resource://drawable/res_app_icon', // Large icon for the notification
    [
      NotificationChannel(
        channelKey: 'basic_channel', // Unique channel key
        channelName: 'Basic notification',
        channelDescription: 'Notification channel for basic test',
        defaultColor: Color(0xFF9D50DD), // Channel color
        ledColor: Colors.white, // LED color for notifications
      ),
    ],
    debug:
        true, // Debugging enabled to check if channel is registered correctly
  );
  _logger.info(
      "Notifications initialized"); // Log that notifications were initialized

  // Initialize database for non-mobile platforms (desktop/web)
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

  // Trigger a notification as soon as the app starts
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'basic_channel', // The notification channel key
        title: 'App Initialized',
        body: 'Your app is now running!',
      ),
    );
  }

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
      home: WelcomePage(toggleTheme: _toggleTheme),
    );
  }
}
