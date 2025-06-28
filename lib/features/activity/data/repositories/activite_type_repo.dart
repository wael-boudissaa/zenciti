import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:zenciti/core/utils/api_client.dart';
import 'package:zenciti/features/activity/domain/entities/activity.dart';
import 'package:zenciti/features/activity/domain/repositories/activity_repo.dart';

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
      final response = await apiClient.get('/activity/type');

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
  Future<List<Activity>> getActivitiesByType(String activityType) async {
    try {
      final response = await apiClient.get('/activity/type/$activityType');
      final List<dynamic> data = response['data'];

      log('Response: $data');
      final activities = data.map((json) => Activity.fromJson(json)).toList();
      return activities;
    } catch (e) {
      print('Error fetching activities by type: $e');
      throw Exception('Failed to load activities by type');
    }
  }

  @override
  Future<List<Activity>> getActivitiesByPopularity() async {
    try {
      final response = await apiClient.get('/activity/populaire');
      final List<dynamic> data = response['data'];

      log('Response: $data');
      final activities = data.map((json) => Activity.fromJson(json)).toList();
      return activities;
    } catch (e) {
      throw Exception('Failed to load activities by popularity');
    }
  }

  @override
  Future<Activity> getActivityById(String activityId) async {
    try {
      final response = await apiClient.get('/activity/single/$activityId');
      final data = response['data'];

      log('Response: $data');
      final activity = Activity.fromJson(data);
      return activity;
    } catch (e) {
      throw Exception('Failed to load activity by ID');
    }
  }

  @override
  Future<List<ActivityProfile>> getActivityRecent(idCient) async {
    try {
      final response = await apiClient.get('/activity/recent/$idCient');
      final List<dynamic> data = await response['data'];

      final activities =
          data.map((json) => ActivityProfile.fromJson(json)).toList();
      return activities;
    } catch (e) {
      throw Exception('Failed to load recent activities');
    }
  }

  @override
  Future<String> createActivity(
      String ActivityId, String idClient, DateTime TimeActivity) async {
    try {
      final response = await apiClient.post('/activity/create', {
        'idActivity': ActivityId,
        'idClient': idClient,
        'timeActivity': TimeActivity.toIso8601String(),
      });

      if (response['status'] == 201) {
        return response['data'].toString();
      } else {
        throw Exception('Failed to create activity');
      }
    } catch (e) {
      throw Exception('Failed to create activity: $e');
    }
  }

  @override
  Future<List<String>> getTimeNotAvaialble(
      String idActivity, String day) async {
    try {
      final response = await apiClient.post(
          '/activity/notAvailable', {'idActivity': idActivity, 'day': day});
      final List<dynamic> data = response['data'];
      log('Response: $data');
      final unavailableTimes = data.map((json) => json.toString()).toList();
      return unavailableTimes;
    } catch (e) {
      throw Exception('Failed to load unavailable times');
    }
  }

  @override
  Future<String> CompleteActivity(String idClientActivity) async {
    try {
      final response = await apiClient.post('/activity/complete', {
        'idClientActivity': idClientActivity,
      });

      if (response['status'] == 200) {
        return response['data']['message'] as String;
      } else {
        throw Exception('Failed to complete activity');
      }
    } catch (e) {
      throw Exception('Failed to complete activity: $e');
    }
  }

  @override
  Future<List<ActivityClient>> getActivityClient(String idClient) async {
    try {
      final response = await apiClient.get('/client/$idClient/activities');
      final List<dynamic> data = response['data']; // Fix: use List<dynamic>
      log('Response: $data');
      final activities = data
          .map((json) => ActivityClient.fromJson(json as Map<String, dynamic>))
          .toList();
      return activities;
    } catch (e) {
      throw Exception('Failed to load client activities: $e');
    }
  }
}
