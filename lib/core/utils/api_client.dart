import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    final decodedResponse = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      log('POST Response: $decodedResponse');
      return decodedResponse;
    } else {
      throw ApiException(
        decodedResponse['data'] ?? 'Unknown error',
        response.statusCode,
      );
    }
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final decodedResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      log('GET Response: $decodedResponse');
      return decodedResponse;
    } else {
      throw ApiException(
        decodedResponse['data'] ?? 'Unknown error',
        response.statusCode,
      );
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    final decodedResponse = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      log('PUT Response: $decodedResponse');
      return decodedResponse;
    } else {
      throw ApiException(
        decodedResponse['data'] ?? 'Unknown error',
        response.statusCode,
      );
    }
  }
}

