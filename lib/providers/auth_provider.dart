import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> checkLoginStatus() async {
    _isAuthenticated = await _authService.isLoggedIn();
    notifyListeners();
  }

  Future<bool> handleSignUp(String email, String password) async {
    return await _authService.signUp(email, password);
  }

  Future<bool> handleLogIn(String email, String password) async {
    bool success = await _authService.logIn(email, password);
    if (success) {
      _isAuthenticated = true;
      notifyListeners();
    }
    return success;
  }

  Future<void> handleLogOut() async {
    await _authService.logOut();
    _isAuthenticated = false;
    notifyListeners();
  }
}