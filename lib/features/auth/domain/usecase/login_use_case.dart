// domain/use_cases/login_use_case.dart

import 'package:zenciti/features/auth/data/repositories/auth_repositorie.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<String> execute(String username, String password) async {
    return await repository.login(username, password);
  }
}
