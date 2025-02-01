import 'package:zenciti/features/auth/domain/entities/user.dart';

abstract class AuthRepo { 
    Future<void> register(User user);
}
