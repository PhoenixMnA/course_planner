import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  bool _isInitialized = false;
  late Course course;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      // Extract the course object passed through the named route arguments
      course = ModalRoute.of(context)!.settings.arguments as Course;
      // Load assignments associated with this specific course ID
      Provider.of<CourseProvider>(context, listen: false).loadAssignments(course.id!);
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final assignments = courseProvider.getAssignmentsForCourse(course.id!);

    return Scaffold(
      appBar: AppBar(
        title: Text(course.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Course Code: ${course.code}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),
            ),
            const Divider(height: 32),
            const Text(
              'Assignments & Deadlines',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: assignments.isEmpty
                  ? const Center(
                      child: Text('No assignments tracked for this course yet.'),
                    )
                  : ListView.builder(
                      itemCount: assignments.length,
                      itemBuilder: (context, index) {
                        final assignment = assignments[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6.0),
                          child: ListTile(
                            leading: Checkbox(
                              value: assignment.isCompleted == 1,
                              onChanged: (bool? value) {
                                // Toggle complete status (U in CRUD)
                                courseProvider.toggleAssignmentStatus(assignment);
                              },
                            ),
                            title: Text(
                              assignment.title,
                              style: TextStyle(
                                decoration: assignment.isCompleted == 1
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            subtitle: Text('Due: ${assignment.deadline}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () {
                                // Delete assignment entry (D in CRUD)
                                courseProvider.removeAssignment(assignment.id!, course.id!);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}