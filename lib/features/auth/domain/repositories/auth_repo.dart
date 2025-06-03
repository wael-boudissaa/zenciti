import 'package:zenciti/features/auth/domain/entities/user.dart';

abstract class AuthRepo { 
    Future<void> register(User user);
    Future<void> login(LoginUser user);
    Future<UserProfile> getUserProfile(String idClient);
    Future<UserProfile> getUserProfileByUsername(String username);

}
