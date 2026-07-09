import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool success = await authProvider.handleSignUp(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign up successful! Please log in.'),
          backgroundColor: Colors.orange,
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Centered Header
                  Text(
                    'Create Account',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Colors.orange,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Email Input
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined, color: Colors.white54),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        value == null || !value.contains('@') ? 'Enter a valid email' : null,
                  ),
                  const SizedBox(height: 16),

                  // Password Input
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline, color: Colors.white54),
                    ),
                    obscureText: true,
                    validator: (value) => value == null || value.length < 6
                        ? 'Password must be at least 6 characters'
                        : null,
                  ),
                  const SizedBox(height: 32),

                  // Submit Button or Loading Indicator
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.orange)
                      : SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _submit,
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 24),

                  // Log In Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.white60),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}