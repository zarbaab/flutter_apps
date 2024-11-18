import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'task_model.dart';
import 'package:intl/intl.dart';

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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 6, // Incremented for new fields and compatibility
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL';
    const doubleType = 'REAL NOT NULL';

    await db.execute('''
    CREATE TABLE tasks ( 
      id $idType, 
      title $textType,
      description $textType,
      isCompleted $boolType,
      time $textType,
      endTime $textType,
      date $textType,
      dueDate $textType,
      isRepeated $boolType,
      repeatFrequency $textType,
      repeatDays $textType,
      completionPercentage $doubleType,
      lastCompleted $textType
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
      await db.execute("ALTER TABLE tasks ADD COLUMN dueDate TEXT");
    }
    if (oldVersion < 4) {
      await db.execute("ALTER TABLE tasks ADD COLUMN endTime TEXT");
    }
    if (oldVersion < 5) {
      await db
          .execute("ALTER TABLE tasks ADD COLUMN completionPercentage REAL");
    }
    if (oldVersion < 6) {
      await db.execute("ALTER TABLE tasks ADD COLUMN lastCompleted TEXT");
    }
  }

  // Task CRUD Operations

  Future<int> createTask(Task task) async {
    final db = await instance.database;
    return await db.insert('tasks', task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> readAllTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks', orderBy: 'date ASC');
    List<Task> tasks = result.map((json) => Task.fromMap(json)).toList();

    for (var task in tasks) {
      task.subtasks = await readSubtasks(task.id!);
    }
    return tasks;
  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return await db.update(
      'tasks',
      task.toMap(),
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

  // Subtask CRUD Operations

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

  // Helper methods for retrieving specific types of tasks

  Future<List<Task>> readTodayTasks() async {
    final db = await instance.database;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final result =
        await db.query('tasks', where: 'date = ?', whereArgs: [today]);
    List<Task> tasks = result.map((json) => Task.fromMap(json)).toList();

    for (var task in tasks) {
      task.subtasks = await readSubtasks(task.id!);
    }
    return tasks;
  }

  Future<List<Task>> readCompletedTasks() async {
    final db = await instance.database;
    final result =
        await db.query('tasks', where: 'isCompleted = ?', whereArgs: [1]);
    List<Task> tasks = result.map((json) => Task.fromMap(json)).toList();

    for (var task in tasks) {
      task.subtasks = await readSubtasks(task.id!);
    }
    return tasks;
  }

  Future<List<Task>> readRepeatedTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks', where: "isRepeated = 1");
    List<Task> tasks = result.map((json) => Task.fromMap(json)).toList();

    for (var task in tasks) {
      task.subtasks = await readSubtasks(task.id!);
    }
    return tasks;
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
