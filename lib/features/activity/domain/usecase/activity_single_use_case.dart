
// domain/use_cases/login_use_case.dart

import 'package:zenciti/features/activity/domain/entities/activity.dart';
import 'package:zenciti/features/activity/domain/repositories/activity_repo.dart';

class ActivitySingleUseCase {
  final ActivityRepo _repository;

  ActivitySingleUseCase(this._repository);

  Future<Activity> execute( String id) async {
    return await _repository.getActivityById(id);

  }

}

