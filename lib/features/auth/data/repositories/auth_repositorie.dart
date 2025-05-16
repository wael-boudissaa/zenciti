// data/repositories/auth_repository_impl.dart
// import 'package:zenciti/core/utils/token.dart';
import 'dart:convert';

import 'package:zenciti/core/utils/api_client.dart';
import 'package:zenciti/features/auth/domain/entities/user.dart';
import 'package:zenciti/features/auth/domain/repositories/auth_repo.dart';
import '../../../../core/utils/token.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
      print('succes');
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
    final token = response['data']['token']; 

    await saveTokens(token);

    // Save token or do something with it
    return;
  } else {
    throw Exception('Failed to login: ${response['data']}');
  }}
}
