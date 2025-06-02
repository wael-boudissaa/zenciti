import 'package:zenciti/features/auth/domain/entities/notification.dart';

abstract class FriendRequestRepo {
  Future<List<FriendRequestList>> getFriendRequestList(String idClient);
}
