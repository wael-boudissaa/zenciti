import 'dart:convert';
import 'package:zenciti/core/utils/api_client.dart';
import 'package:zenciti/features/auth/domain/entities/user.dart';
import 'package:zenciti/features/auth/domain/repositories/auth_repo.dart';
import '../../../../core/utils/token.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class AuthRepositoryImpl implements AuthRepo {
  final ApiClient apiClient;

  AuthRepositoryImpl({required this.apiClient});

  @override
  Future<void> register(User user) async {
    final response = await apiClient.post(
      '/signup',
      {
        'email': user.email,
        'username': user.username,
        'first_name': user.firstName,
        'last_name': user.lastName,
        'address': user.address,
        'phone_number': user.phone,
        'password': user.password,
        'gender': "male",
        'type': "client"
      },
    );

    if (response['status'] != 'success') {
      // throw Exception('Failed to register user');
      print('success');
    } else {
      String refreshToken = response['token'];
      await saveTokens(refreshToken);
    }
  }

  @override
  Future<void> login(LoginUser user) async {
    final response = await apiClient.post('/login', {
      'email': user.email,
      'password': user.password,
    });

    if (response['status'] == 200) {
      final data = response['data'];

      // Save tokens and ids to secure storage
      final token = data['token'] as String;
      final refreshToken = data['user']['refreshToken'] as String?;
      final idProfile = data['user']['idProfile'] as String?;
      final idClient = data['user']['idClient'] as String?;
      final userType = data['user']['type'] as String?;
      final username = data['user']['username'] as String?;
      final String? idAdminActivity = data['idAdminActivity'] as String?;
      final bool isAdminActivity = data['isAdminActivity'] as bool;
      await storage.write(key: 'token', value: token);
      if (refreshToken != null) {
        await storage.write(key: 'refreshToken', value: refreshToken);
      }
      if (idProfile != null) {
        await storage.write(key: 'idProfile', value: idProfile);
      }
      if (idClient != null) {
        await storage.write(key: 'idClient', value: idClient);
      }
      if (userType != null) {
        await storage.write(key: 'userType', value: userType);
      }
      if (username != null) {
        await storage.write(key: 'username', value: username);
      }

      await storage.write(
        key: 'isAdmin',
        value: isAdminActivity ? 'true' : 'false',
      );
      if (idAdminActivity != null) {
        await storage.write(key: 'idAdminActivity', value: idAdminActivity);
      } // Success, return
      return;
    } else {
      throw Exception('Failed to login: ${response['data']}');
    }
  }

  @override
  Future<UserProfile> getUserProfile(String idClient) async {
    final response = await apiClient.get('/clientinformation/$idClient');
    if (response['status'] == 200) {
      final data = response['data'];
      return UserProfile.fromJson(data);
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  @override
  Future<UserProfile> getUserProfileByUsername(String username) async {
    final response = await apiClient.get('/usernameinformation/$username');
    if (response['status'] == 200) {
      final data = response['data'];
      return UserProfile.fromJson(data);
    } else {
      throw Exception('Failed to load user profile by username');
    }
  }

  @override
  Future<List<String>> getUsernameByPrefix(String prefix) async {
    final response = await apiClient.get('/username?prefix=$prefix');
    if (response['status'] == 200) {
      final data = response['data']['usernames'];
      return List<String>.from(data);
    } else {
      throw Exception('Failed to load usernames by prefix');
    }
  }
}

