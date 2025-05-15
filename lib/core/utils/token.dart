
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

// Save Tokens
Future<void> saveTokens(String accessToken) async {
  await storage.write(key: 'access_token', value: accessToken);
}

// Get Access Token
Future<String?> getAccessToken() async {
  return await storage.read(key: 'access_token');
}

// Delete Tokens (Logout)
Future<void> clearTokens() async {
  await storage.delete(key: 'access_token');
  await storage.delete(key: 'refresh_token');
}
