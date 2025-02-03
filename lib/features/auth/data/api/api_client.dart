import 'dart:convert';
import 'dart:developer'; // Import developer for logging
import 'package:http/http.dart' as http;
import 'package:zenciti/core/utils/token.dart';

class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
        String? token = await getAccessToken();

    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json', 
          // "Authorization": "Bearer $token",
},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decodedResponse = jsonDecode(response.body);
      
      // Use print or log for debugging
      print('Response: $decodedResponse');
      log('Response: $decodedResponse');

      return decodedResponse;
    } else {
      throw Exception('Failed to load data: ${response.body}');
    }
  }
}
