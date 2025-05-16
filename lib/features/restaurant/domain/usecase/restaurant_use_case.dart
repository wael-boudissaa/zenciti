// domain/use_cases/login_use_case.dart

import 'package:zenciti/features/restaurant/domain/entities/menu.dart';
import 'package:zenciti/features/restaurant/domain/entities/tables.dart';
import 'package:zenciti/features/restaurant/domain/repositories/restaurant_repo.dart';

class RestaurantUseCase {
  final RestaurantRepo _repository;

  RestaurantUseCase(this._repository);

  Future<List<Restaurant>> execute() async {
    return await _repository.getAllRestaurant();
  }

  Future<Restaurant> getRestaurantById(String id) async {
    return await _repository.getRestaurantById(id);
  }

  Future<List<MenuItem>> getMenuActife(String idRestaurant) async {
    return await _repository.getMenuActife(idRestaurant);
  }
}
