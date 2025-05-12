// domain/use_cases/login_use_case.dart


import 'package:zenciti/features/activity/domain/entities/activity.dart';
import 'package:zenciti/features/activity/domain/repositories/activity_repo.dart';

class ActivityTypeUseCase {
  final ActivityRepo _repository;

  ActivityTypeUseCase(this._repository);

  Future<List<TypeActivity>> execute() async {
    return await _repository.getTypeActivities();
  }

}

