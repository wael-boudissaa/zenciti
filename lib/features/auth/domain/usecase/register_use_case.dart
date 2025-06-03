import 'package:zenciti/features/auth/domain/entities/user.dart';
import 'package:zenciti/features/auth/domain/repositories/auth_repo.dart';

class RegisterUseCase {
  final AuthRepo _authRepo;

  RegisterUseCase(this._authRepo);

  Future<void> execute(User user) async {
    return await _authRepo.register(user);
  }

  Future<UserProfile> getUserProfile(String idClient) async {
    return await _authRepo.getUserProfile(idClient);
  }

  Future<UserProfile> getUserProfileByUsername(String username) async {
    return await _authRepo.getUserProfileByUsername(username);
  }
}
