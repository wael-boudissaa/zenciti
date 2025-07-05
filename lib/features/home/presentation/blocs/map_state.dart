import 'package:zenciti/features/home/domain/entities/map.dart';

abstract class MapState {}

class MapInitials extends MapState {}

class MapLoading extends MapState {}

class MapSuccess extends MapState {
  final List<MapInformation> locations;
  MapSuccess(this.locations);
}

class MapFailure extends MapState {
  final String error;

  MapFailure(this.error);
}
