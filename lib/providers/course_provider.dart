import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/assignment.dart';
import 'package:course_planner/services/db_helper.dart';

class CourseProvider with ChangeNotifier {
  List<Course> _courses = [];
  final Map<int, List<Assignment>> _assignmentsByCourse = {};
  bool _isLoading = false;

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;

  List<Assignment> getAssignmentsForCourse(int courseId) {
    return _assignmentsByCourse[courseId] ?? [];
  }

  // READ Courses (R in CRUD)
  Future<void> loadCourses() async {
    _isLoading = true;
    notifyListeners();

    // Simulated latency block to let the skeleton render clearly
    await Future.delayed(const Duration(milliseconds: 600));

    try {
      _courses = await DBHelper.instance.getAllCourses();
    } catch (e) {
      debugPrint("Error loading courses: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // CREATE Course (C in CRUD)
  Future<void> addCourse(String name, String code) async {
    final newCourse = Course(name: name, code: code);
    await DBHelper.instance.insertCourse(newCourse);
    await loadCourses();
  }

  // UPDATE Course (U in CRUD)
  Future<void> updateCourse(int id, String name, String code) async {
    final updatedCourse = Course(id: id, name: name, code: code);
    await DBHelper.instance.updateCourse(updatedCourse);
    await loadCourses();
  }

  // DELETE Course (D in CRUD)
  Future<void> removeCourse(int id) async {
    await DBHelper.instance.deleteCourse(id);
    await loadCourses();
  }

  // READ Assignments (R in CRUD)
  Future<void> loadAssignments(int courseId) async {
    try {
      final assignments = await DBHelper.instance.getAssignmentsByCourse(courseId);
      _assignmentsByCourse[courseId] = assignments;
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading assignments: $e");
    }
  }

  // CREATE Assignment (C in CRUD)
  Future<void> addAssignment(int courseId, String title, String deadline) async {
    final newAssignment = Assignment(
      courseId: courseId,
      title: title,
      deadline: deadline,
      isCompleted: 0,
    );
    await DBHelper.instance.insertAssignment(newAssignment);
    await loadAssignments(courseId);
  }

  // UPDATE Assignment Details (U in CRUD)
  Future<void> updateAssignment(Assignment assignment) async {
    await DBHelper.instance.updateAssignment(assignment);
    await loadAssignments(assignment.courseId);
  }

  // UPDATE Assignment Status (U in CRUD)
  Future<void> toggleAssignmentStatus(Assignment assignment) async {
    final updatedAssignment = Assignment(
      id: assignment.id,
      courseId: assignment.courseId,
      title: assignment.title,
      deadline: assignment.deadline,
      isCompleted: assignment.isCompleted == 1 ? 0 : 1,
    );
    await DBHelper.instance.updateAssignment(updatedAssignment);
    await loadAssignments(assignment.courseId);
  }

  // DELETE Assignment (D in CRUD)
  Future<void> removeAssignment(int assignmentId, int courseId) async {
    await DBHelper.instance.deleteAssignment(assignmentId);
    await loadAssignments(courseId);
  }
}