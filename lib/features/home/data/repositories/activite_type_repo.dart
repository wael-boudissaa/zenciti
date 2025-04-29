import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zenciti/core/utils/api_client.dart';
import 'package:zenciti/features/home/data/models/models.dart';
import 'package:zenciti/features/home/domain/entities/activity.dart';
import 'package:zenciti/features/home/domain/repositories/activity_repo.dart';

// Future<List<ActivityType>> fetchActivityTypes() async {
// final response = await http.get(Uri.parse('http://localhost:8080/activite/type'));
//
//   if (response.statusCode == 200) {
//     final List<dynamic> data = jsonDecode(response.body);
//     return data.map((json) => ActivityType.fromJson(json)).toList();
//   } else {
//     throw Exception('Failed to load activity types');
//   }
// }

class ActiviteTypeRepoImp implements ActivityRepo {
  // final String baseUrl;

  final ApiClient apiClient;

  ActiviteTypeRepoImp({
    required this.apiClient,
  });

  @override
  Future<List<TypeActivity>> getTypeActivities() async {
    try {
      final response = await apiClient.get('/activite/type');

      final List<dynamic> data = response['data'];

      final activityTypes =
          data.map((json) => TypeActivity.fromJson(json)).toList();
      return activityTypes;
    } catch (e) {
      print('Error fetching activity types: $e');
      throw Exception('Failed to load activity types');
    }
  }

  @override
  Future<List<Activity>> getActivitiesByType(String activityType)async {
      try{
          final response = await apiClient.get('/activite/type/$activityType');
          final List<dynamic> data = response['data'];
          final activities = data.map((json) => Activity.fromJson(json)).toList();
          return activities;


      }catch(e){
        print('Error fetching activities by type: $e');
        throw Exception('Failed to load activities by type');
      }
  }

}
