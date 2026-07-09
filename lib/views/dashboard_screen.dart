import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/course_provider.dart';
import 'package:shimmer/shimmer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for frame mount, then load courses safely
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<CourseProvider>(context, listen: false).loadCourses();
      }
    });
  }

  Widget _buildSkeletonLoader() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: const Color(0xFF2A2A2A),
          highlightColor: const Color(0xFF3D3D3D),
          child: Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 160,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.white, 
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 70,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white, 
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 24, 
                    height: 24, 
                    decoration: const BoxDecoration(
                      color: Colors.white, 
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 24, 
                    height: 24, 
                    decoration: const BoxDecoration(
                      color: Colors.white, 
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final courseProvider = Provider.of<CourseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Course Planner',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white70),
            tooltip: 'Log Out',
            onPressed: () async {
              final navigator = Navigator.of(context);
              await authProvider.handleLogOut();
              navigator.pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: courseProvider.isLoading
          ? _buildSkeletonLoader()
          : courseProvider.courses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.school_outlined, size: 64, color: Colors.white24),
                      SizedBox(height: 16),
                      Text(
                        'No courses added yet.\nTap the + button to create one!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.white38),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: courseProvider.courses.length,
                  itemBuilder: (context, index) {
                    final course = courseProvider.courses[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        title: Text(
                          course.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          course.code,
                          style: const TextStyle(color: Colors.orangeAccent),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: Colors.orange),
                              tooltip: 'Edit Course',
                              onPressed: () {
                                Navigator.pushNamed(context, '/edit', arguments: course);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              tooltip: 'Delete Course',
                              onPressed: () {
                                if (course.id != null) {
                                  courseProvider.removeCourse(course.id!);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}