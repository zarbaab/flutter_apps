import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;
import 'welcomepage.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('MyAppLogger');

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up logging level
  _logger.level = Level.INFO;
  _logger.onRecord.listen((record) {
    _logger.info('${record.level.name}: ${record.time}: ${record.message}');
  });

  // Initialize Awesome Notifications
  AwesomeNotifications().initialize(
    'resource://drawable/res_app_icon',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notification',
        channelDescription: 'Notification channel for basic test',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
    ],
    debug: true,
  );
  _logger.info("Notifications initialized");

  // Request notification permissions on mobile
  if (Platform.isAndroid || Platform.isIOS) {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  // Initialize sqflite for desktop platforms
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

  @override
  void initState() {
    super.initState();
    // Trigger welcome notification
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'basic_channel',
        title: 'Welcome to TODO App!',
        body: 'Manage your tasks, simplify your life!',
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
