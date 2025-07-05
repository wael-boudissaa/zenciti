import 'dart:convert';
import 'dart:ffi';
import 'package:zenciti/core/utils/api_client.dart';
import 'package:zenciti/features/auth/domain/entities/user.dart';
import 'package:zenciti/features/auth/domain/repositories/auth_repo.dart';
import 'package:zenciti/features/home/domain/entities/map.dart';
import 'package:zenciti/features/home/domain/repositories/map_repo.dart';
import '../../../../core/utils/token.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class MapImpl implements MapRepository {
  final ApiClient apiClient;

  MapImpl({required this.apiClient});

  @override
  Future<List<MapInformation>> getLocations(
      double longitude, double latitude) async {
    final response = await apiClient.post(
      '/locations',
      {
        'longitude': longitude,
        'latitude': latitude,
      },
    );
    if (response['status'] == 200) {
      final List<MapInformation> locations = [];
      for (var item in response['data']) {
        locations.add(MapInformation.fromJson(item));
      }
      return locations;
    } else {
      throw Exception('Failed to fetch locations');
    }
  }
}
