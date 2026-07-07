class Course {
  final int? id; // 'id' is optional because SQLite will generate it automatically
  final String name;
  final String code;

  Course({
    this.id,
    required this.name,
    required this.code,
  });

  // 1. Convert a Course object into a Map (Required for saving data into SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'course_name': name,
      'course_code': code,
    };
  }

  // 2. Convert a Map from SQLite back into a clean Course object for your UI
  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      name: map['course_name'],
      code: map['course_code'],
    );
  }
}