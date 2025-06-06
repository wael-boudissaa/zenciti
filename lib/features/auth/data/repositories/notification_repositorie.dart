import 'package:zenciti/core/utils/api_client.dart';
import 'package:zenciti/features/auth/domain/entities/notification.dart';
import 'package:zenciti/features/auth/domain/repositories/notification_repo.dart';

class NotificationRepoImpl implements FriendRequestRepo {
  final ApiClient apiClient;

  NotificationRepoImpl({required this.apiClient});

  @override
  Future<List<FriendRequestList>> getFriendRequestList(String idClient) async {
    final response = await apiClient.get('/getfriendship/$idClient');

    if (response['status'] == 200) {
      final List<dynamic> data = response['data'];

      return data
          .map<FriendRequestList>((item) => FriendRequestList.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load friend requests');
    }
  }

  @override
  Future<void> acceptFriendRequest(String idFriendship) {
    return apiClient.post(
        '/acceptfriendship', {'idFriendship': idFriendship}).then((response) {
      if (response['status'] != 200) {
        throw Exception('Failed to accept friend request');
      }
    });
  }

  @override
  Future<void> sendRequest(String usernameSender, String usernameReceiver) {
    return apiClient.post('/sendrequest', {
      'from_client': usernameSender,
      'to_client': usernameReceiver,
    }).then((response) {
      if (response['status'] != 200) {
        throw Exception('Failed to send request');
      }
    });
  }
}
