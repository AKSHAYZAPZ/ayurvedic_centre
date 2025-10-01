import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants.dart';
import '../models/branch.dart';
import '../models/patient.dart';
import '../models/treatment.dart';

class ApiService {
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String> login(String username, String password) async {
    final uri = Uri.parse(BASE_URL + ENDPOINT_LOGIN);
    final request = http.MultipartRequest('POST', uri);
    request.fields['username'] = username;
    request.fields['password'] = password;

    final streamed = await request.send();
    final resp = await http.Response.fromStream(streamed);

    if (resp.statusCode == 200) {
      final body = json.decode(resp.body);
      final token =
          body['token'] ?? body['access_token'] ?? body['data']?['token'];
      if (token == null) throw Exception('Invalid Credentials');
      return token.toString();
    } else {
      throw Exception('Login failed: ${resp.statusCode}');
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    final headers = {'Accept': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<List<Patient>> fetchPatients() async {
    final uri = Uri.parse(BASE_URL + ENDPOINT_PATIENT_LIST);
    final headers = await _getHeaders();
    final resp = await http.get(uri, headers: headers);
    print(resp);
    if (resp.statusCode == 200) {
      final body = json.decode(resp.body);
      final items = body['patient'] as List?;
      if (items != null) return items.map((e) => Patient.fromJson(e)).toList();
      return [];
    } else {
      throw Exception('Failed to load patients: ${resp.statusCode}');
    }
  }

  Future<List<Branch>> fetchBranches() async {
    final uri = Uri.parse(BASE_URL + ENDPOINT_BRANCH_LIST);
    final headers = await _getHeaders();
    final resp = await http.get(uri, headers: headers);

    if (resp.statusCode == 200) {
      final body = json.decode(resp.body);
      final items = body['branches'] as List?;
      if (items != null) return items.map((e) => Branch.fromJson(e)).toList();
      return [];
    } else {
      throw Exception('Failed to load branches');
    }
  }

  Future<List<Treatment>> fetchTreatments() async {
    final uri = Uri.parse(BASE_URL + ENDPOINT_TREATMENT_LIST);
    final headers = await _getHeaders();
    final resp = await http.get(uri, headers: headers);

    if (resp.statusCode == 200) {
      final body = json.decode(resp.body);
      final items = body['treatments'] as List?;
      if (items != null)
        return items.map((e) => Treatment.fromJson(e)).toList();
      return [];
    } else {
      throw Exception('Failed to load treatments');
    }
  }

  Future<void> updatePatient(Map<String, String> fields) async {
    final uri = Uri.parse(BASE_URL + ENDPOINT_PATIENT_UPDATE);
    final headers = await _getHeaders();

    final request = http.MultipartRequest('POST', uri);
    request.fields.addAll(fields);
    request.headers.addAll(headers);

    final streamed = await request.send();
    final resp = await http.Response.fromStream(streamed);

    if (resp.statusCode != 200) {
      throw Exception(
          'Failed to update patient: ${resp.statusCode} ${resp.body}');
    }
  }
}
