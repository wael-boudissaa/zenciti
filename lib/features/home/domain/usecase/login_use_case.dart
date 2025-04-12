// domain/use_cases/login_use_case.dart

import 'package:zenciti/features/auth/data/repositories/auth_repositorie.dart';
import 'package:zenciti/features/auth/domain/entities/user.dart';
import 'package:zenciti/features/auth/domain/repositories/auth_repo.dart';

class LoginUseCase {
  final AuthRepo _repository;

  LoginUseCase(this._repository);

  Future<void> execute(LoginUser user) async {
     await _repository.login(LoginUser(email: user.email, password: user.password));
  }
}
