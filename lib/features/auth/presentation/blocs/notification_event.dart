
part of 'notification_bloc.dart';

class NotificationEvent {
  NotificationEvent();
}

class NotificationGet extends NotificationEvent {
  final String idClient;
  NotificationGet(this.idClient);
}

class AcceptRequest extends NotificationEvent {
  final String idFriendship;
  AcceptRequest(this.idFriendship);
}
