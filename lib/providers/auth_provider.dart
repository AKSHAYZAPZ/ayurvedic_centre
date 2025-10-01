import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/datasources/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService apiService;
  bool loading = false;
  String? token;

  AuthProvider({ApiService? service}) : apiService = service ?? ApiService() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final t = prefs.getString('token');
    if (t != null && t.isNotEmpty) {
      token = t;
      notifyListeners();
    }
  }

  Future<void> login(String username, String password) async {
    loading = true;
    notifyListeners();
    try {
      final t = await apiService.login(username, password);
      token = t;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', t);
      notifyListeners();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }

  String? getToken() => token;
  bool _obscure = true;

  bool get obscure => _obscure;

  void toggle() {
    _obscure = !_obscure;
    notifyListeners();
  }
}
