import 'package:equatable/equatable.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object> get props => [];
}

class ActivityGet extends ActivityEvent {
  final String activityType;

  ActivityGet(this.activityType);
}

class ActivityPopulaireGet extends ActivityEvent {}
class GetActivityById extends ActivityEvent {
  final String idActivity;

  GetActivityById(this.idActivity);
}

class ActivityTypeGet extends ActivityEvent {}

class ActivityRecentGet extends ActivityEvent {
  final String idClient;

  ActivityRecentGet(this.idClient);
}
