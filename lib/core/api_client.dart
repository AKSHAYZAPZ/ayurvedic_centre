import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client httpClient;
  String? token;
  ApiClient({http.Client? client}) : httpClient = client ?? http.Client();

  void setToken(String t) => token = t;

  Future<http.Response> get(String url) async {
    final uri = Uri.parse(url);
    final headers = <String, String>{ 'Accept': 'application/json' };
    if (token != null && token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return await httpClient.get(uri, headers: headers);
  }

  Future<http.Response> postMultipart(String url, Map<String, String> fields) async {
    final uri = Uri.parse(url);
    final request = http.MultipartRequest('POST', uri);
    request.fields.addAll(fields);
    if (token != null && token!.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    final streamed = await request.send();
    return await http.Response.fromStream(streamed);
  }

  dynamic decodeBody(http.Response resp) {
    try {
      return json.decode(resp.body);
    } catch (_) {
      return resp.body;
    }
  }
}
