import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/course_provider.dart';
import 'views/login_screen.dart';
import 'views/signup_screen.dart';
import 'views/dashboard_screen.dart';
import 'views/add_screen.dart';  // <-- ADDED THIS
import 'views/edit_screen.dart';

void main() async {
  // Ensure Flutter bindings are initialized before accessing local storage
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Check login status on startup to auto-route the user
    Provider.of<AuthProvider>(context, listen: false).checkLoginStatus();

    return MaterialApp(
      title: 'Course Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      // Read authentication state to choose initial view
      initialRoute: Provider.of<AuthProvider>(context).isAuthenticated ? '/dashboard' : '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/add': (context) => const AddScreen(),   // <-- ADDED THIS
        '/edit': (context) => const EditScreen(), // <-- ADDED THIS
      },
    );
  }
}