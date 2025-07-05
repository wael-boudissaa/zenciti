class MapInformation {
  final String id;
  final String name;
  final String type;
  final String address;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final String phoneNumber;
  final double distance;
  final String distanceFormatted;

  MapInformation({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.phoneNumber,
    required this.distance,
    required this.distanceFormatted,
  });

  factory MapInformation.fromJson(Map<String, dynamic> json) {
    return MapInformation(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      phoneNumber: json['phoneNumber'] as String,
      distance: (json['distance'] as num).toDouble(),
      distanceFormatted: json['distanceFormatted'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'phoneNumber': phoneNumber,
      'distance': distance,
      'distanceFormatted': distanceFormatted,
    };
  }
}
