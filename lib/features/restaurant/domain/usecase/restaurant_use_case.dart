// domain/use_cases/login_use_case.dart

import 'package:zenciti/features/restaurant/domain/entities/menu.dart';
import 'package:zenciti/features/restaurant/domain/entities/restaurant.dart';
import 'package:zenciti/features/restaurant/domain/entities/reviews.dart';
import 'package:zenciti/features/restaurant/domain/entities/tables.dart';
import 'package:zenciti/features/restaurant/domain/repositories/restaurant_repo.dart';

class RestaurantUseCase {
  final RestaurantRepo _repository;

  RestaurantUseCase(this._repository);

  Future<List<Restaurant>> execute() async {
    return await _repository.getAllRestaurant();
  }

  Future<Restaurant> getRestaurantById(String id) async {
    return await _repository.getRestaurantById(id);
  }

  Future<List<MenuItem>> getMenuActife(String idRestaurant) async {
    return await _repository.getMenuActife(idRestaurant);
  }

  Future<void> OrderFood(String idReservation, List<FoodItem> food) async {
    _repository.OrderFood(idReservation, food);
  }

  Future<String> createReservation(String idClient, String idRestaurant,
      String idTable, DateTime timeFrom, int numberOfPeople) async {
    return await _repository.createReservation(
        idClient, idRestaurant, idTable, timeFrom, numberOfPeople);
  }

  Future<String> ratingRestaurant(
      String idRestaurant, idClient, comment, int rating) async {
    return await _repository.ratingRestaurant(
        idRestaurant, idClient, rating, comment);
  }

  Future<List<ReviewProfile>> getFriendsReviews(
      String idRestaurant, String idClient) async {
    return await _repository.getFriendsReviews(idRestaurant, idClient);
  }

  Future<List<ReservationClient>> getReservationsByClient(
      String idClient) async {
    return await _repository.getReservationsByClient(idClient);
  }
}
