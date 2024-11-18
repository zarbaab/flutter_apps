import 'dart:convert';

class Task {
  int? id;
  String title;
  String description;
  bool isCompleted;
  String time;
  String date; // Store as String for compatibility with SQLite
  DateTime? dueDate; // Due date stored as DateTime
  String endTime;
  bool isRepeated;
  String repeatFrequency; // e.g., 'daily', 'weekly'
  List<String>? repeatDays; // e.g., ['Monday', 'Wednesday']
  List<Subtask> subtasks; // List of subtasks
  DateTime? lastCompleted;
  double _completionPercentage = 0.0; // Private field for completion percentage

  // Constructor
  Task({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.time = '',
    this.date = '',
    this.dueDate,
    this.endTime = '23:59',
    this.isRepeated = false,
    this.repeatFrequency = '',
    this.repeatDays,
    this.subtasks = const [], // Default empty list
    this.lastCompleted,
  });

  // Getter for completionPercentage based on completed subtasks
  double get completionPercentage {
    if (subtasks.isEmpty) {
      return isCompleted
          ? 100.0
          : 0.0; // 100% if marked complete with no subtasks
    }
    final completedCount =
        subtasks.where((subtask) => subtask.isCompleted).length;
    return (completedCount / subtasks.length) * 100.0; // Convert to percentage
  }

  // Setter for completionPercentage (for manual updates)
  set completionPercentage(double value) {
    _completionPercentage = value;
  }

  // Convert Task to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'time': time,
      'date': date,
      'dueDate': dueDate?.toIso8601String(),
      'endTime': endTime,
      'isRepeated': isRepeated ? 1 : 0,
      'repeatFrequency': repeatFrequency,
      'repeatDays': repeatDays?.join(','),
      'lastCompleted': lastCompleted?.toIso8601String(),
      'completionPercentage': _completionPercentage, // Store manual value
      'subtasks':
          jsonEncode(subtasks.map((subtask) => subtask.toMap()).toList()),
    };
  }

  // Create Task from Map (for SQLite retrieval)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: _parseString(map['title']),
      description: _parseString(map['description']),
      isCompleted: map['isCompleted'] == 1,
      time: _parseString(map['time']),
      date: _parseString(map['date']),
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      endTime: _parseString(map['endTime'] ?? '23:59'),
      isRepeated: map['isRepeated'] == 1,
      repeatFrequency: _parseString(map['repeatFrequency']),
      repeatDays: map['repeatDays']?.split(','),
      lastCompleted: map['lastCompleted'] != null
          ? DateTime.parse(map['lastCompleted'])
          : null,
      subtasks: map['subtasks'] != null
          ? (jsonDecode(map['subtasks']) as List<dynamic>)
              .map((subtaskJson) => Subtask.fromJson(subtaskJson))
              .toList()
          : [],
    );
  }

  // Static utility function to safely parse string from dynamic data
  static String _parseString(dynamic value) {
    if (value == null) return '';
    if (value is String) {
      return value;
    } else if (value is List<int>) {
      return utf8.decode(value); // Decode byte array to string
    }
    return value
        .toString(); // Fallback to toString if it's not a string or byte array
  }
}

// Subtask model to be included in Task
class Subtask {
  final int? id;
  final String title;
  bool isCompleted;

  Subtask({
    this.id,
    required this.title,
    this.isCompleted = false,
  });

  // Convert Subtask to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  // Create Subtask from Map (for SQLite retrieval)
  factory Subtask.fromJson(Map<String, dynamic> json) {
    return Subtask(
      id: json['id'] as int?,
      title: json['title'] as String? ?? '',
      isCompleted: (json['isCompleted'] as int?) == 1,
    );
  }
}
