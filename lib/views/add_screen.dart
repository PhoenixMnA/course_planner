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
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Add Item',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          bottom: const TabBar(
            indicatorColor: Colors.orange,
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.white60,
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'New Course'),
              Tab(text: 'New Assignment'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // TAB 1: ADD COURSE FORM
            SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _courseFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _courseNameController,
                      decoration: const InputDecoration(
                        labelText: 'Course Name',
                        prefixIcon: Icon(Icons.book_outlined, color: Colors.white54),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter a name' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _courseCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Course Code (e.g. CS 302)',
                        prefixIcon: Icon(Icons.code_outlined, color: Colors.white54),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter a code' : null,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (_courseFormKey.currentState!.validate()) {
                            final navigator = Navigator.of(context);
                            await courseProvider.addCourse(
                              _courseNameController.text.trim(),
                              _courseCodeController.text.trim(),
                            );
                            navigator.pop();
                          }
                        },
                        child: const Text(
                          'Save Course',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // TAB 2: ADD ASSIGNMENT FORM
            SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _assignmentFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      initialValue: _selectedCourseId,
                      dropdownColor: const Color(0xFF1E1E1E),
                      decoration: const InputDecoration(
                        labelText: 'Link to Course',
                        prefixIcon: Icon(Icons.class_outlined, color: Colors.white54),
                      ),
                      items: courseProvider.courses.map((course) {
                        return DropdownMenuItem<int>(
                          value: course.id,
                          child: Text(
                            course.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedCourseId = value),
                      validator: (value) => value == null ? 'Please select a course' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _assignmentTitleController,
                      decoration: const InputDecoration(
                        labelText: 'Assignment Title',
                        prefixIcon: Icon(Icons.assignment_outlined, color: Colors.white54),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter a title' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _assignmentDeadlineController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Select Deadline',
                        prefixIcon: Icon(Icons.calendar_today_outlined, color: Colors.white54),
                        suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.orange),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.dark(
                                  primary: Colors.orange,
                                  onPrimary: Colors.black,
                                  surface: Color(0xFF1E1E1E),
                                  onSurface: Colors.white,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (pickedDate != null) {
                          String formattedDate =
                              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

                          setState(() {
                            _assignmentDeadlineController.text = formattedDate;
                          });
                        }
                      },
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please select a deadline' : null,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (_assignmentFormKey.currentState!.validate()) {
                            final navigator = Navigator.of(context);
                            await courseProvider.addAssignment(
                              _selectedCourseId!,
                              _assignmentTitleController.text.trim(),
                              _assignmentDeadlineController.text.trim(),
                            );
                            navigator.pop();
                          }
                        },
                        child: const Text(
                          'Save Assignment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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