
class MapEvent {
  MapEvent();
}

class MapSubmitted extends MapEvent {
  final double longitude;
  final double latitude;

  MapSubmitted({required this.longitude, required this.latitude});
}
