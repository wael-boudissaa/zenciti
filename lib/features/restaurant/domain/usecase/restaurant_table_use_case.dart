// domain/use_cases/login_use_case.dart

import 'package:zenciti/features/restaurant/domain/entities/tables.dart';
import 'package:zenciti/features/restaurant/domain/repositories/restaurant_repo.dart';

class RestaurantTablesUseCase {
  final RestaurantRepo _repository;

  RestaurantTablesUseCase(this._repository);

  Future<List<RestaurantTable>> execute(String id, DateTime timeSlot) async {
    return await _repository.getTableRestaurant(id, timeSlot);
  }
}
