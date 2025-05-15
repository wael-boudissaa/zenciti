
import 'package:zenciti/features/restaurant/domain/entities/tables.dart';

abstract class RestaurantRepo {
  // Future<void> createActivity(String activityName, String activityDescription, String activityType, String activityDate, String activityTime);
  // Future<void> updateActivity(String activityId, String activityName, String activityDescription, String activityType, String activityDate, String activityTime);
  // Future<void> deleteActivity(String activityId);
  Future<List<RestaurantTable>> getTableRestaurant(String idRestaurant);
  Future<List<Restaurant>> getAllRestaurant();
    Future<Restaurant> getRestaurantById(String id);
  // Future<List<Activity>> getActivitiesByType(String activityType);
  // Future<List<Activity>> getActivitiesByPopularity();
  // Future<Activity> getActivityById(String activityId);
}
