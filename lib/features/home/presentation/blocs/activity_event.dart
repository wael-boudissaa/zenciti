import 'package:equatable/equatable.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();
  
  @override
  List<Object> get props => [];
}

class ActivityGet extends ActivityEvent {
      final String activityType;

  ActivityGet( this.activityType);
  
}

class ActivityTypeGet extends ActivityEvent {
  
}

