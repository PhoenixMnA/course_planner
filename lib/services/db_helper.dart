import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/course.dart';
import '../models/assignment.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  // Get the database instance (initializes it if it doesn't exist yet)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('course_planner.db');
    return _database!;
  }

  // Initialize database path on the device
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Open the database and set up tables
    return await openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure, // FIX: Enables CASCADE deletion support in SQLite
      onCreate: _createDB,
    );
  }

  // Configure database settings (Turn on foreign keys)
  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // CREATE TABLES
  Future _createDB(Database db, int version) async {
    // 1. Create Courses Table
    await db.execute('''
      CREATE TABLE courses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        course_name TEXT NOT NULL,
        course_code TEXT NOT NULL
      )
    ''');

    // 2. Create Assignments Table (with foreign key linking back to courses)
    await db.execute('''
      CREATE TABLE assignments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        course_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        deadline TEXT NOT NULL,
        is_completed INTEGER NOT NULL,
        FOREIGN KEY (course_id) REFERENCES courses (id) ON DELETE CASCADE
      )
    ''');
  }

  // =========================================================================
  // COURSE CRUD OPERATIONS
  // =========================================================================

  // CREATE (Insert) a new course
  Future<int> insertCourse(Course course) async {
    final db = await instance.database;
    return await db.insert('courses', course.toMap());
  }

  // READ (Fetch) all courses from the database
  Future<List<Course>> getAllCourses() async {
    final db = await instance.database;
    final result = await db.query('courses', orderBy: 'course_name ASC');

    return result.map((json) => Course.fromMap(json)).toList();
  }

  // UPDATE an existing course's details
  Future<int> updateCourse(Course course) async {
    final db = await instance.database;
    return await db.update(
      'courses',
      course.toMap(),
      where: 'id = ?',
      whereArgs: [course.id],
    );
  }

  // DELETE a course
  Future<int> deleteCourse(int id) async {
    final db = await instance.database;
    return await db.delete(
      'courses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // =========================================================================
  // ASSIGNMENT CRUD OPERATIONS
  // =========================================================================

  // CREATE (Insert) a new assignment
  Future<int> insertAssignment(Assignment assignment) async {
    final db = await instance.database;
    return await db.insert('assignments', assignment.toMap());
  }

  // FIX: Renamed from getAssignmentsForCourse to getAssignmentsByCourse to match provider expectations
  Future<List<Assignment>> getAssignmentsByCourse(int courseId) async {
    final db = await instance.database;
    final result = await db.query(
      'assignments',
      where: 'course_id = ?',
      whereArgs: [courseId],
    );

    return result.map((json) => Assignment.fromMap(json)).toList();
  }

  // UPDATE an assignment (e.g., changing title, due date, or marking as completed)
  Future<int> updateAssignment(Assignment assignment) async {
    final db = await instance.database;
    return await db.update(
      'assignments',
      assignment.toMap(),
      where: 'id = ?',
      whereArgs: [assignment.id],
    );
  }

  // DELETE an assignment
  Future<int> deleteAssignment(int id) async {
    final db = await instance.database;
    return await db.delete(
      'assignments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close database when done
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}