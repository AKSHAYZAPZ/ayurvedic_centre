import '../data/datasources/api_service.dart';
import '../data/models/patient.dart';

class HomeRepository {
  final ApiService apiService;
  HomeRepository(this.apiService);

  Future<List<Patient>> getPatients() => apiService.fetchPatients();
}
