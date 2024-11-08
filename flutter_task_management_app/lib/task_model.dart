class Task {
  final int? id;
  final String title;
  final String note;
  bool isCompleted; // Changed from final to allow updates
  final String time;
  final String date;
  final List<String> repeatDays;
  List<Subtask> subtasks; // New field for subtasks

  Task({
    this.id,
    required this.title,
    required this.note,
    this.isCompleted = false, // Default to false if not provided
    required this.time,
    required this.date,
    this.repeatDays = const [],
    this.subtasks =
        const [], // Initialize with an empty list if no subtasks are provided
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'note': note,
        'isCompleted': isCompleted ? 1 : 0,
        'time': time,
        'date': date,
        'repeatDays': repeatDays.join(','),
      };

  static Task fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as int?,
        title: json['title'] as String,
        note: json['note'] as String,
        isCompleted: (json['isCompleted'] as int) == 1,
        time: json['time'] as String,
        date: json['date'] as String,
        repeatDays: (json['repeatDays'] as String?)?.split(',') ?? [],
        subtasks: [], // Initially set subtasks to an empty list; populate separately if needed
      );

  // Calculate completion percentage based on completed subtasks
  double get completionPercentage {
    if (subtasks.isEmpty) {
      return isCompleted
          ? 100
          : 0; // 100% if task is marked complete without subtasks
    }
    final completedCount =
        subtasks.where((subtask) => subtask.isCompleted).length;
    return (completedCount / subtasks.length) * 100;
  }
}

// Subtask model to be included in Task
class Subtask {
  final int? id;
  final String title;
  bool isCompleted; // Changed from final to allow updates

  Subtask({
    this.id,
    required this.title,
    this.isCompleted = false, // Default to false if not provided
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isCompleted': isCompleted ? 1 : 0,
      };

  static Subtask fromJson(Map<String, dynamic> json) => Subtask(
        id: json['id'] as int?,
        title: json['title'] as String,
        isCompleted: (json['isCompleted'] as int) == 1,
      );
}
