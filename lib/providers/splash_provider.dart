import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashProvider extends ChangeNotifier {
  bool loading = true;
  bool? isAuthenticated;

  SplashProvider() {
    checkAuth();
  }

  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    isAuthenticated = token != null && token.isNotEmpty;
    loading = false;
    notifyListeners();
  }
}
