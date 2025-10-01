import 'package:flutter/material.dart';

import '../data/models/patient.dart';
import '../repositories/home_repository.dart';

class HomeProvider extends ChangeNotifier {
  final HomeRepository repository;

  bool loading = true;
  List<Patient> patients = [];
  TextEditingController searchController = TextEditingController();

  HomeProvider({required this.repository});

  Future<void> loadPatients() async {
    loading = true;
    notifyListeners();
    try {
      patients = await repository.getPatients();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> refreshPatients() async {
    try {
      patients = await repository.getPatients();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
