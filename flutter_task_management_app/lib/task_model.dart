class Task {
  final int? id;
  final String title;
  final String note;
  final bool isCompleted;
  final String time;
  final String date;

  Task({
    this.id,
    required this.title,
    required this.note,
    required this.isCompleted,
    required this.time,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'note': note,
    'isCompleted': isCompleted ? 1 : 0,
    'time': time,
    'date': date,
  };

  static Task fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] as int?,
    title: json['title'] as String,
    note: json['note'] as String,
    isCompleted: json['isCompleted'] == 1,
    time: json['time'] as String,
    date: json['date'] as String,
  );
}
