import 'package:zenciti/features/home/domain/entities/activity.dart';

abstract class ActivityRepo {
    // Future<void> createActivity(String activityName, String activityDescription, String activityType, String activityDate, String activityTime);
    // Future<void> updateActivity(String activityId, String activityName, String activityDescription, String activityType, String activityDate, String activityTime);
    // Future<void> deleteActivity(String activityId);
    Future<List<TypeActivity>> getTypeActivities();
    // Future<Activity> getActivityById(String activityId);

}
