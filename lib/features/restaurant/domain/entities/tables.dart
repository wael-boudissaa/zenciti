class RestaurantTable {
  final String idTable;
  final String idRestaurant;
  final DateTime reservationTime;
  final int posX;
  final int posY;
  final bool isAvailable;
  final int durationMinutes;

  RestaurantTable({
    required this.idTable,
    required this.idRestaurant,
    required this.reservationTime,
    required this.posX,
    required this.posY,
    required this.isAvailable,
    required this.durationMinutes,
  });

  factory RestaurantTable.fromJson(Map<String, dynamic> json) {
    return RestaurantTable(
      idTable: json['idTable'],
      idRestaurant: json['idRestaurant'],
      reservationTime: DateTime.parse(json['reservation_time']),
      posX: json['posX'],
      posY: json['posY'],
      isAvailable: json['is_available'],
      durationMinutes: json['duration_minutes'],
    );
  }
    Map<String, dynamic> toJson() {
        return {
        'idTable': idTable,
        'idRestaurant': idRestaurant,
        'reservation_time': reservationTime.toIso8601String(),
        'posX': posX,
        'posY': posY,
        'is_available': isAvailable,
        'duration_minutes': durationMinutes,
        };
    }
}

class Restaurant {
  final String idRestaurant;
  final String nameR;
  final String idAdmineRestaurant;
  final String description;
  final String image;
  final int capacity;
  final String location;

  Restaurant({
    required this.idRestaurant,
    required this.nameR,
    required this.idAdmineRestaurant,
    required this.description,
    required this.image,
    required this.capacity,
    required this.location,
  });
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      idRestaurant: json['idRestaurant'],
      nameR: json['name'],
      idAdmineRestaurant: json['idAdminRestaurant'],
      description: json['description'],
      image: json['image'],
      capacity: json['capacity'],
      location: json['location'],
    );
  }
    Map<String, dynamic> toJson() {
        return {
        'idRestaurant': idRestaurant,
        'nameR': nameR,
        'idAdmineRestaurant': idAdmineRestaurant,
        'description': description,
        'image': image,
        'capacity': capacity,
        'location': location,
        };
    }

}
