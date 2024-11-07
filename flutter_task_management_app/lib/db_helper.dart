import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // for non-mobile platform support
import 'package:path/path.dart';
import 'task_model.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

// Create an instance of the FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3, // Incremented version for subtasks feature
      onCreate: _createDB,
      onUpgrade: _upgradeDB, // Add onUpgrade callback
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';

    await db.execute('''
    CREATE TABLE tasks ( 
      id $idType, 
      title $textType,
      note $textType,
      isCompleted $boolType,
      time $textType,
      date $textType,
      repeatDays TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE subtasks (
      id $idType,
      title $textType,
      isCompleted $boolType,
      parentTaskId INTEGER NOT NULL,
      FOREIGN KEY (parentTaskId) REFERENCES tasks (id) ON DELETE CASCADE
    )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE tasks ADD COLUMN repeatDays TEXT");
    }
    if (oldVersion < 3) {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS subtasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        isCompleted BOOLEAN NOT NULL,
        parentTaskId INTEGER NOT NULL,
        FOREIGN KEY (parentTaskId) REFERENCES tasks (id) ON DELETE CASCADE
      )
      ''');
    }
  }

  // Method to request exact alarm permission
  Future<void> requestExactAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      // Request the permission
      await Permission.scheduleExactAlarm.request();
    }
  }

  // Task Methods
  Future<int> createTask(Task task) async {
    final db = await instance.database;
    int id = await db.insert('tasks', task.toJson());
    task.id = id; // Ensure the task ID is set

    // Schedule a notification for the new task
    await scheduleNotification(task);

    return id;
  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    int result = await db.update(
      'tasks',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );

    // Reschedule the notification for the updated task
    await scheduleNotification(task);

    return result;
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    // Cancel the notification for the deleted task
    await flutterLocalNotificationsPlugin.cancel(id);
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Task>> readAllTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks', orderBy: 'date ASC');
    return result.map((json) => Task.fromJson(json)).toList();
  }

  // Function to schedule a notification
  Future<void> scheduleNotification(Task task) async {
    // Request exact alarm permission
    await requestExactAlarmPermission();

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'task_channel',
        'Task Notifications',
        channelDescription: 'Notifications for task reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    // Calculate the time one minute before the due date
    final DateTime localTime =
        task.dueDate.subtract(const Duration(minutes: 1));
    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(localTime, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,
      'Task Reminder',
      '${task.title} is due soon',
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Subtask Methods
  Future<int> createSubtask(int parentTaskId, String title) async {
    final db = await instance.database;
    return await db.insert('subtasks', {
      'title': title,
      'isCompleted': 0,
      'parentTaskId': parentTaskId,
    });
  }

  Future<List<Subtask>> readSubtasks(int parentTaskId) async {
    final db = await instance.database;
    final result = await db.query('subtasks',
        where: 'parentTaskId = ?', whereArgs: [parentTaskId]);
    return result.map((json) => Subtask.fromJson(json)).toList();
  }

  Future<int> updateSubtask(int id, bool isCompleted) async {
    final db = await instance.database;
    return await db.update(
      'subtasks',
      {'isCompleted': isCompleted ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteSubtask(int id) async {
    final db = await instance.database;
    return await db.delete(
      'subtasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Other Methods for Tasks
  Future<List<Task>> readTodayTasks() async {
    final db = await instance.database;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final result =
        await db.query('tasks', where: 'date = ?', whereArgs: [today]);
    List<Task> tasks = result.map((json) => Task.fromJson(json)).toList();

    // Load subtasks for each task
    for (var task in tasks) {
      task.subtasks = await readSubtasks(task.id!);
    }
    return tasks;
  }

  Future<List<Task>> readCompletedTasks() async {
    final db = await instance.database;
    final result =
        await db.query('tasks', where: 'isCompleted = ?', whereArgs: [1]);
    List<Task> tasks = result.map((json) => Task.fromJson(json)).toList();

    // Load subtasks for each task
    for (var task in tasks) {
      task.subtasks = await readSubtasks(task.id!);
    }
    return tasks;
  }

  Future<List<Task>> readRepeatedTasks() async {
    final db = await instance.database;
    final result = await db.query(
      'tasks',
      where: "repeatDays IS NOT NULL AND repeatDays != ''",
    );

    final logger = Logger(); // Create an instance of Logger

    // Use logger instead of print
    for (var row in result) {
      logger.d("Task: ${row['title']} - Repeat Days: ${row['repeatDays']}");
    }

    List<Task> tasks = result.map((json) => Task.fromJson(json)).toList();

    // Load subtasks for each task
    for (var task in tasks) {
      task.subtasks = await readSubtasks(task.id!);
    }
    return tasks;
  }
}
