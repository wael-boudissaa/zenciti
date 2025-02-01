
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../features/tasks/data/models/categorie.dart';

class ApiService {
  final String baseUrl = "http://192.168.1.45:8080"; // Replace with your backend URL

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
