import 'package:equatable/equatable.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();
  
  @override
  List<Object> get props => [];
}

class ActivityGet extends ActivityEvent {
  
}

class ActivityTypeGet extends ActivityEvent {
  
}

