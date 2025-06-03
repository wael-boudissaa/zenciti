// import 'package:zenciti/features/auth/domain/entities/notification.dart';

import 'package:zenciti/features/auth/domain/entities/notification.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSucces extends NotificationState {
  List<FriendRequestList> friendRequestList;
  NotificationSucces(this.friendRequestList);
}

class NotificationFailure extends NotificationState {
  final String error;

  NotificationFailure(this.error);
}
class AcceptRequestState extends NotificationState {
  final String message;

  AcceptRequestState(this.message);
}
class SendRequestState extends NotificationState {
  final String message;

  SendRequestState(this.message);
}
