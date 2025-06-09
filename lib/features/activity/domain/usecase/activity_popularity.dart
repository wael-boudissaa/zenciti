// domain/use_cases/login_use_case.dart

import 'package:zenciti/features/activity/domain/entities/activity.dart';
import 'package:zenciti/features/activity/domain/repositories/activity_repo.dart';

class ActivityPopularityUseCase {
  final ActivityRepo _repository;

  ActivityPopularityUseCase(this._repository);

  Future<List<Activity>> execute() async {
    return await _repository.getActivitiesByPopularity();
  }

  Future<List<ActivityProfile>> executeRecent(String idClient) async {
    return await _repository.getActivityRecent(idClient);
  }

}
