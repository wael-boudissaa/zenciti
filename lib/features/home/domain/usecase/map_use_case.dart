// domain/use_cases/login_use_case.dart


import 'package:zenciti/features/home/domain/entities/map.dart';
import 'package:zenciti/features/home/domain/repositories/map_repo.dart';

class MapUseCase {
  final MapRepository _repository;

  MapUseCase(this._repository);

  Future<List<MapInformation>> execute(
      double longitude, double latitude) async {
    return await _repository.getLocations(longitude, latitude);
  }
}
