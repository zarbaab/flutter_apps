class Task {
  final int? id;
  final String title;
  final String note;
  final bool isCompleted;
  final String time;
  final String date;
  final List<String> repeatDays; // Field to store selected days

  Task({
    this.id,
    required this.title,
    required this.note,
    required this.isCompleted,
    required this.time,
    required this.date,
    this.repeatDays = const [], // Default to empty list if not provided
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'note': note,
        'isCompleted': isCompleted ? 1 : 0,
        'time': time,
        'date': date,
        'repeatDays': repeatDays.isNotEmpty ? repeatDays.join(',') : null,
      };

  static Task fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as int?,
        title: json['title'] as String? ?? '', // Provide default values
        note: json['note'] as String? ?? '',
        isCompleted: (json['isCompleted'] as int? ?? 0) == 1,
        time: json['time'] as String? ?? '',
        date: json['date'] as String? ?? '',
        repeatDays: (json['repeatDays'] as String?)?.split(',') ?? [],
      );
}
