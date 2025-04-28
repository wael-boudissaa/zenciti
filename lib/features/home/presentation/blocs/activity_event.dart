import 'package:equatable/equatable.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();
  
  @override
  List<Object> get props => [];
}

class ActivityGet extends ActivityEvent {
  final String id;
  
  const ActivityGet({required this.id});
  
  @override
  List<Object> get props => [id];
}
