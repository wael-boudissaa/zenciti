import 'package:zenciti/features/restaurant/domain/entities/restaurant.dart';
import 'package:zenciti/features/restaurant/domain/entities/reviews.dart';
import 'package:zenciti/features/restaurant/domain/entities/tables.dart';

import '../entities/menu.dart';

abstract class RestaurantRepo {
  // Future<void> createActivity(String activityName, String activityDescription, String activityType, String activityDate, String activityTime);
  // Future<void> updateActivity(String activityId, String activityName, String activityDescription, String activityType, String activityDate, String activityTime);
  // Future<void> deleteActivity(String activityId);
  Future<List<RestaurantTable>> getTableRestaurant(
      String idRestaurant, DateTime timeSlot);
  Future<List<Restaurant>> getAllRestaurant();
  Future<Restaurant> getRestaurantById(String id);
  Future<List<MenuItem>> getMenuActife(String idRestaurant);
  void OrderFood(String idReservation, List<FoodItem> food);
  Future<String> createReservation(String idClient, String idRestaurant,
      String idTable, DateTime timeFrom, int numberOfPeople);
  Future<String> ratingRestaurant(
    String idRestaurant,
    String idClient,
    int rating,
    String comment,
  );
  Future<List<ReviewProfile>> getFriendsReviews(
      String idRestaurant, String idClient);
  Future<List<ReservationClient>> getReservationsByClient(String idClient);
  // Future<List<Activity>> getActivitiesByType(String activityType);
  // Future<List<Activity>> getActivitiesByPopularity();
  // Future<Activity> getActivityById(String activityId);
}
