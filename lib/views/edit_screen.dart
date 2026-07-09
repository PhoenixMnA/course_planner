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
      Provider.of<CourseProvider>(
        context,
        listen: false,
      ).loadAssignments(course.id!);
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final assignments = courseProvider.getAssignmentsForCourse(course.id!);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          course.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Code Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
              ),
              child: Text(
                'Course Code: ${course.code}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Assignments & Deadlines',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: assignments.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.assignment_turned_in_outlined,
                            size: 56,
                            color: Colors.white24,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No assignments tracked for this course yet.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white38,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: assignments.length,
                      itemBuilder: (context, index) {
                        final assignment = assignments[index];
                        final isDone = assignment.isCompleted == 1;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 4.0,
                            ),
                            leading: Checkbox(
                              value: isDone,
                              activeColor: Colors.orange,
                              checkColor: Colors.black,
                              side: const BorderSide(
                                color: Colors.white54,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onChanged: (bool? value) {
                                // Toggle complete status (U in CRUD)
                                courseProvider.toggleAssignmentStatus(
                                  assignment,
                                );
                              },
                            ),
                            title: Text(
                              assignment.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isDone ? Colors.white38 : Colors.white,
                                decoration: isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                decorationColor: Colors.white38,
                              ),
                            ),
                            subtitle: Text(
                              'Due: ${assignment.deadline}',
                              style: TextStyle(
                                color: isDone
                                    ? Colors.white24
                                    : Colors.orangeAccent,
                                fontSize: 13,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                              tooltip: 'Delete Assignment',
                              onPressed: () {
                                // Delete assignment entry (D in CRUD)
                                courseProvider.removeAssignment(
                                  assignment.id!,
                                  course.id!,
                                );
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
