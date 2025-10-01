import '../data/datasources/api_service.dart';
import '../data/models/patient.dart';

class PatientRepository {
  final ApiService apiService;
  PatientRepository(this.apiService);

  Future<List<Patient>> getPatients() => apiService.fetchPatients();

  Future<void> addOrUpdatePatient(Map<String, String> fields) =>
      apiService.updatePatient(fields);

  Future<List<dynamic>> getBranchesAndTreatments() async {
    final branches = await apiService.fetchBranches();
    final treatments = await apiService.fetchTreatments();
    return [branches, treatments];
  }
}
