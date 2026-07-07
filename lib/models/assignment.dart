class Assignment {
  final int? id;
  final int courseId; // Links this assignment to a specific course
  final String title;
  final String deadline;
  final int isCompleted; // SQLite doesn't store booleans, so we use 0 (false) or 1 (true)

  Assignment({
    this.id,
    required this.courseId,
    required this.title,
    required this.deadline,
    this.isCompleted = 0, // Defaults to incomplete
  });

  // Convert Assignment object into a Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'deadline': deadline,
      'is_completed': isCompleted,
    };
  }

  // Convert Map from SQLite back into an Assignment object
  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      id: map['id'],
      courseId: map['course_id'],
      title: map['title'],
      deadline: map['deadline'],
      isCompleted: map['is_completed'],
    );
  }
}