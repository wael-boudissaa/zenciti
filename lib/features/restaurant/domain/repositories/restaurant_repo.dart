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
  Future<String> createReservation(String idClient,String idRestaurant, String idTable,
      DateTime timeFrom, DateTime timeTo, int numberOfPeople);
  // Future<List<Activity>> getActivitiesByType(String activityType);
  // Future<List<Activity>> getActivitiesByPopularity();
  // Future<Activity> getActivityById(String activityId);
}
