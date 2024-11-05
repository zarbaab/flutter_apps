import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // for non-mobile platform support
import 'package:path/path.dart';
import 'task_model.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;

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
      version: 2, // Increment the database version
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
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE tasks ADD COLUMN repeatDays TEXT");
    }
  }

  Future<int> createTask(Task task) async {
    final db = await instance.database;
    return await db.insert('tasks', task.toJson());
  }

  Future<List<Task>> readAllTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks', orderBy: 'date ASC');
    return result
        .map((json) => Task.fromJson(json))
        .toList(); // Convert to List
  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return await db.update(
      'tasks',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Task>> readTodayTasks() async {
    final db = await instance.database;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final result =
        await db.query('tasks', where: 'date = ?', whereArgs: [today]);
    return result
        .map((json) => Task.fromJson(json))
        .toList(); // Convert to List
  }

  Future<List<Task>> readCompletedTasks() async {
    final db = await instance.database;
    final result =
        await db.query('tasks', where: 'isCompleted = ?', whereArgs: [1]);
    return result
        .map((json) => Task.fromJson(json))
        .toList(); // Convert to List
  }

  Future<List<Task>> readRepeatedTasks() async {
    final db = await instance.database;
    final result = await db.query(
      'tasks',
      where: "repeatDays IS NOT NULL AND repeatDays != ''",
    );

    // Debugging print to verify repeatDays values
    for (var row in result) {
      print("Task: ${row['title']} - Repeat Days: ${row['repeatDays']}");
    }

    return result
        .map((json) => Task.fromJson(json))
        .toList(); // Convert to List
  }
}
