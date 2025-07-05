import 'dart:ffi';

import 'package:zenciti/features/home/domain/entities/map.dart';

abstract class MapRepository {
  Future<List<MapInformation>> getLocations(double longitude, double latitude);
}
