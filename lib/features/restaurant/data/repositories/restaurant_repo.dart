import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:zenciti/core/utils/api_client.dart';
import 'package:zenciti/features/restaurant/domain/entities/menu.dart';
import 'package:zenciti/features/restaurant/domain/entities/tables.dart';
import 'package:zenciti/features/restaurant/domain/repositories/restaurant_repo.dart';

// Future<List<ActivityType>> fetchActivityTypes() async {
// final response = await http.get(Uri.parse('http://localhost:8080/activite/type'));
//
//   if (response.statusCode == 200) {
//     final List<dynamic> data = jsonDecode(response.body);
//     return data.map((json) => ActivityType.fromJson(json)).toList();
//   } else {
//     throw Exception('Failed to load activity types');
//   }
// }

class RestaurantRepoImpl implements RestaurantRepo {
  // final String baseUrl;

  final ApiClient apiClient;

  RestaurantRepoImpl({
    required this.apiClient,
  });

  @override
  Future<List<RestaurantTable>> getTableRestaurant(String idRestaurant) async {
    try {
      final response = await apiClient.get('/restaurant/tables/$idRestaurant');
      log('Raw response from /restaurant/tables/$idRestaurant → $response');
      final List<dynamic> data = response['data'];

      log('Response: $data');
      final restaurantTables =
          data.map((json) => RestaurantTable.fromJson(json)).toList();
      return restaurantTables;
    } catch (e) {
      print('Error fetching restaurant tables: $e');
      throw Exception('Failed to load restaurant tables');
    }
  }

  @override
  Future<List<Restaurant>> getAllRestaurant() async {
    try {
      final response = await apiClient.get('/restaurant');
      log('Raw response from /restaurant → $response');
      final List<dynamic> data = response['data'];
      log('Response: $data');
      final restaurant = data.map((json) => Restaurant.fromJson(json)).toList();
      return restaurant;
    } catch (e) {
      print('Error fetching restaurant: $e');
      throw Exception('Failed to load restaurant');
    }
  }

  @override
  Future<Restaurant> getRestaurantById(String id) async {
    try {
      final response = await apiClient.get('/restaurant/$id');
      final restaurant = Restaurant.fromJson(response['data']);
      return restaurant;
    } catch (e) {
      print('Error fetching restaurant by id: $e');
      throw Exception('Failed to load restaurant by id');
    }
  }

  @override
  Future<List<MenuItem>> getMenuActife(String idRestaurant) async {
    try {
      final fullUrl = '/menu/actif/$idRestaurant';
      print('GET → $fullUrl');
      final response = await apiClient.get(fullUrl);
      log('Raw response from /restaurant/menu/$idRestaurant → $response');
      final List<dynamic> data = response['data'];
      log('Response: $data');
      final menuItems = data.map((json) => MenuItem.fromJson(json)).toList();
      return menuItems;
    } catch (e) {
      print('Error fetching active menu: $e');
      throw Exception('Failed to load active menu');
    }
  }
}
