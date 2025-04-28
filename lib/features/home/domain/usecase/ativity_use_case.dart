// domain/use_cases/login_use_case.dart

import 'package:zenciti/features/home/domain/entities/activity.dart';
import 'package:zenciti/features/home/domain/repositories/activity_repo.dart';

class ActivityUseCase {
  final ActivityRepo _repository;

  ActivityUseCase(this._repository);

  Future<List<TypeActivity>> execute() async {
    return await _repository.getTypeActivities();
  }
}
