
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/categorie.dart';




class ApiService {
  final String _baseUrl = "http://10.0.2.2:8000"; // Replace with your base URL

  Future<List<Category>> fetchCategories() async {
    final url = Uri.parse("$_baseUrl/categories");
    try {
      final response = await http.get(url);

      // Log response details
      print("API Response Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => Category.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load categories: ${response.statusCode}");
      }
    } catch (e) {
      // Log any error
      print("Error in fetchCategories: $e");
      rethrow;
    }
  }
}
