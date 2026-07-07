import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _courseFormKey = GlobalKey<FormState>();
  final _assignmentFormKey = GlobalKey<FormState>();

  // Course Controllers
  final _courseNameController = TextEditingController();
  final _courseCodeController = TextEditingController();

  // Assignment Controllers
  final _assignmentTitleController = TextEditingController();
  final _assignmentDeadlineController = TextEditingController();
  int? _selectedCourseId;

  @override
  void dispose() {
    _courseNameController.dispose();
    _courseCodeController.dispose();
    _assignmentTitleController.dispose();
    _assignmentDeadlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Item'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'New Course'),
              Tab(text: 'New Assignment'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // TAB 1: ADD COURSE FORM
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _courseFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _courseNameController,
                      decoration: const InputDecoration(labelText: 'Course Name', border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _courseCodeController,
                      decoration: const InputDecoration(labelText: 'Course Code (e.g. CS 302)', border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter a code' : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        if (_courseFormKey.currentState!.validate()) {
                          // Fix: Save a reference to the Navigator before entering the async block
                          final navigator = Navigator.of(context);
                          await courseProvider.addCourse(
                            _courseNameController.text.trim(),
                            _courseCodeController.text.trim(),
                          );
                          navigator.pop();
                        }
                      },
                      child: const Text('Save Course'),
                    ),
                  ],
                ),
              ),
            ),

            // TAB 2: ADD ASSIGNMENT FORM
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _assignmentFormKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<int>(
                      initialValue: _selectedCourseId, // Fix: Changed 'value' to 'initialValue' to fix deprecation warning
                      decoration: const InputDecoration(labelText: 'Link to Course', border: OutlineInputBorder()),
                      items: courseProvider.courses.map((course) {
                        return DropdownMenuItem<int>(
                          value: course.id,
                          child: Text(course.name),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedCourseId = value),
                      validator: (value) => value == null ? 'Please select a course' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _assignmentTitleController,
                      decoration: const InputDecoration(labelText: 'Assignment Title', border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _assignmentDeadlineController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Select Deadline',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today, color: Colors.indigo),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          String formattedDate = 
                              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                          
                          setState(() {
                            _assignmentDeadlineController.text = formattedDate;
                          });
                        }
                      },
                      validator: (value) => value == null || value.isEmpty ? 'Please select a deadline' : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        if (_assignmentFormKey.currentState!.validate()) {
                          // Fix: Save a reference to the Navigator before entering the async block
                          final navigator = Navigator.of(context);
                          await courseProvider.addAssignment(
                            _selectedCourseId!,
                            _assignmentTitleController.text.trim(),
                            _assignmentDeadlineController.text.trim(),
                          );
                          navigator.pop();
                        }
                      },
                      child: const Text('Save Assignment'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}