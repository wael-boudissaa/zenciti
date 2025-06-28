import 'package:zenciti/features/activity/domain/entities/activity.dart';

abstract class ActivityRepo {
  // Future<void> createActivity(String activityName, String activityDescription, String activityType, String activityDate, String activityTime);
  // Future<void> updateActivity(String activityId, String activityName, String activityDescription, String activityType, String activityDate, String activityTime);
  // Future<void> deleteActivity(String activityId);
  Future<List<TypeActivity>> getTypeActivities();
  Future<List<Activity>> getActivitiesByType(String activityType);
  Future<List<Activity>> getActivitiesByPopularity();
  Future<Activity> getActivityById(String activityId);
  Future<List<ActivityProfile>> getActivityRecent(idCient);
  Future<String> createActivity(
      String ActivityId, String idClient, DateTime TimeActivity);
  Future<List<String>> getTimeNotAvaialble(String idActivity, String day);
  Future<String> CompleteActivity(String idClientActivity);
}
