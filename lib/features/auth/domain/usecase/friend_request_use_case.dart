// domain/use_cases/login_use_case.dart

import 'package:zenciti/features/auth/domain/entities/notification.dart';
import 'package:zenciti/features/auth/domain/repositories/notification_repo.dart';

class FriendRequestUseCase {
  final FriendRequestRepo _repository;

  FriendRequestUseCase(this._repository);

  Future<List<FriendRequestList>> execute(String idClient) async {
    return await  _repository.getFriendRequestList(idClient);
  }
}
