// data/repositories/auth_repository_impl.dart
// import 'package:zenciti/core/utils/token.dart';
import 'package:zenciti/features/auth/domain/entities/user.dart';
import 'package:zenciti/features/auth/domain/repositories/auth_repo.dart';
import '../../../../core/utils/token.dart';
import '../api/api_client.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:convert';
final storage = FlutterSecureStorage();
class AuthRepositoryImpl implements AuthRepo {
  final ApiClient apiClient;

  // Define a constructor that accepts ApiClient
  AuthRepositoryImpl({required this.apiClient});

  @override
  Future<void> register(User user) async {
    final response = await apiClient.post(
      '/signup',
      {
        'email': user.email,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'address': user.address,
        'phone': user.phone,
        'password': user.password,
      },
    );

    if (response['status'] != 'success') {
      throw Exception('Failed to register user');
    }
    else { 

        String refreshToken = response['token'];
        await saveTokens(refreshToken);

    }
  }


  @override
  Future<void> login(LoginUser user) async {
  
      final Map response = await apiClient.post('/login', {
        'email': user.email,
        'password': user.password,
      });
      if (response.containsKey('error')) {
        throw Exception(response['error']);
      } else {
        String refreshToken = response['token'];
        await saveTokens(refreshToken);
      }
  }
}
