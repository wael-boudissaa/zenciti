import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:zenciti/core/utils/api_client.dart';
import 'package:zenciti/features/restaurant/domain/entities/menu.dart';
import 'package:zenciti/features/restaurant/domain/entities/restaurant.dart';
import 'package:zenciti/features/restaurant/domain/entities/reviews.dart';
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
  Future<List<RestaurantTable>> getTableRestaurant(
      String idRestaurant, DateTime timeSlot) async {
    try {
      final body = {
        "idRestaurant": idRestaurant,
        "timeSlot": timeSlot.toIso8601String(),
      };

      final response = await apiClient.post(
        '/restaurant/tables',
        body,
      );

      log('Raw response from /restaurant/tables → $response');

      final List<dynamic> data = response['data'];
      log('Response data: $data');

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

  @override
  void OrderFood(String idReservation, List<FoodItem> food) async {
    try {
      final fullUrl = '/order/place';
      print('POST → $fullUrl');
      final body = {
        'idReservation': idReservation,
        'food': food.map((item) => item.toJson()).toList(),
      };
      final response = await apiClient.post(fullUrl, body);
      log('Raw response from /order/place → $response');
      final data = response['data'];
      log('Response: $data');
    } catch (e) {
      print('Error placing order: $e');
      throw Exception('Failed to place order');
    }
  }

  @override
  Future<String> createReservation(
    String idClient,
    String idRestaurant,
    String idTable,
    DateTime timeFrom,
    int numberOfPeople,
  ) async {
    try {
      final fullUrl = '/reservation';
      final body = {
        'idClient': idClient,
        'idRestaurant': idRestaurant,
        'idTable': idTable,
        'timeFrom': timeFrom.toIso8601String(),
        'numberOfPeople': numberOfPeople,
      };

      final response = await apiClient.post(fullUrl, body);
      return response['data'];
    } catch (e) {
      if (e is ApiException) {
        throw Exception(
            e.message); // 👈 This now returns your backend's "data" field
      } else {
        throw Exception('Unexpected error: $e');
      }
    }
  }

  @override
  Future<String> ratingRestaurant(
      String idRestaurant, String idClient, int rating, String comment) async {
    try {
      final fullUrl = '/restaurant/rating';
      print('POST → $fullUrl');
      final body = {
        'idRestaurant': idRestaurant,
        'idClient': idClient,
        'rating': rating,
        'comment': comment,
      };
      final response = await apiClient.post(fullUrl, body);
      log('Raw response from /restaurant/rating → $response');
      final data = response['data']['message'];
      if (data != null && data is String) {
        return data;
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print('Error rating restaurant: $e');
      throw Exception('Failed to rate restaurant');
    }
  }

  @override
  Future<List<ReviewProfile>> getFriendsReviews(
      String idRestaurant, String idClient) async {
    try {
      final fullUrl = '/friends/reviews';
      print('GET → $fullUrl');
      final body = {
        'idRestaurant': idRestaurant,
        'idClient': idClient,
      };
      final response = await apiClient.post(fullUrl, body);
      log('Raw response from /friends/reviews → $response');
      final List<dynamic> data = response['data'];
      log('Response: $data');
      final reviews = data.map((json) => ReviewProfile.fromJson(json)).toList();
      return reviews;
    } catch (e) {
      print('Error fetching friends reviews: $e');
      throw Exception('Failed to load friends reviews');
    }
  }

  @override
  Future<List<ReservationClient>> getReservationsByClient(
      String idClient) async {
    try {
      final fullUrl = '/client/$idClient/reservations';
      print('GET → $fullUrl');
      final response = await apiClient.get(fullUrl);
      log('Raw response from /reservation/client/$idClient → $response');
      final List<dynamic> data = response['data'];
      log('Response: $data');
      final reservations =
          data.map((json) => ReservationClient.fromJson(json)).toList();
      return reservations;
    } catch (e) {
      print('Error fetching reservations by client: $e');
      throw Exception('Failed to load reservations by client');
    }
  }
}
