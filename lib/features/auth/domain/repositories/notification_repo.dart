import 'package:zenciti/features/auth/domain/entities/notification.dart';

abstract class FriendRequestRepo {
  Future<List<FriendRequestList>> getFriendRequestList(String idClient);
  Future<void> acceptFriendRequest(String idFriendship);
  Future<void> sendRequest(String usernameSender, String usernameReceiver);
}
