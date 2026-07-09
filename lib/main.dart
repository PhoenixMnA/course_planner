import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart'; // Ensure google_fonts is in pubspec.yaml
import 'providers/auth_provider.dart';
import 'providers/course_provider.dart';
import 'views/login_screen.dart';
import 'views/signup_screen.dart';
import 'views/dashboard_screen.dart';
import 'views/add_screen.dart';
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
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212), // Deep Pitch Black background
        primaryColor: Colors.orange,
        colorScheme: const ColorScheme.dark(
          primary: Colors.orange,
          secondary: Colors.orangeAccent,
          surface: Color(0xFF1E1E1E), // Dark surface for cards/containers
        ),

        // Global Card Styling
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1E1E),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        // Typography using Google Fonts (Poppins)
        textTheme: TextTheme(
          displayLarge: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineMedium: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
          titleLarge: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),

        // Form Text Field Themes
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          hintStyle: const TextStyle(color: Colors.white38),
          labelStyle: const TextStyle(color: Colors.white70),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.orange, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white12),
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        // Floating Action Button Theme
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.black,
        ),
      ),
      // Read authentication state to choose initial view
      initialRoute: Provider.of<AuthProvider>(context).isAuthenticated ? '/dashboard' : '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/add': (context) => const AddScreen(),
        '/edit': (context) => const EditScreen(),
      },
    );
  }
}