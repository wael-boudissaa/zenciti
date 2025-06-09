// domain/use_cases/login_use_case.dart

import 'package:zenciti/features/activity/domain/entities/activity.dart';
import 'package:zenciti/features/activity/domain/repositories/activity_repo.dart';

class ActivityUseCase {
  final ActivityRepo _repository;

  ActivityUseCase(this._repository);

  Future<List<Activity>> execute(String id) async {
    return await _repository.getActivitiesByType(id);
  }

  Future<List<ActivityProfile>> executeRecent(String idClient) async {
    return await _repository.getActivityRecent(idClient);
  }

  Future<void> createActivity(
      String activityId, String idClient, DateTime timeActivity) async {
    return await _repository.createActivity(activityId, idClient, timeActivity);
  }

  Future<List<String>> getTimeNotAvailable(
      String idActivity, String day) async {
    return await _repository.getTimeNotAvaialble(idActivity, day);
  }
}
