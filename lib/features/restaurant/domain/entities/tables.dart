class RestaurantTable {
  final String? idTable;
  final String? idReservation;
  final int? numberOfPeople;
  final int? posX;
  final int? posY;
  final DateTime? timeFrom;
  final DateTime? timeTo;
  final String? status; // new field

  RestaurantTable({
    required this.idTable,
    required this.idReservation,
    required this.numberOfPeople,
    required this.posX,
    required this.posY,
    required this.timeFrom,
    required this.timeTo,
    required this.status,
  });

  factory RestaurantTable.fromJson(Map<String, dynamic> json) {
    return RestaurantTable(
      idTable: json['idTable'],
      idReservation: json['idReservation'],
      numberOfPeople: json['numberOfPeople'],
      posX: json['posX'],
      posY: json['posY'],
      timeFrom:
          json['timeFrom'] != null ? DateTime.parse(json['timeFrom']) : null,
      timeTo: json['timeTo'] != null ? DateTime.parse(json['timeTo']) : null,
      status: json['status'], // parse status
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idTable': idTable,
      'idReservation': idReservation,
      'numberOfPeople': numberOfPeople,
      'posX': posX,
      'posY': posY,
      'timeFrom': timeFrom?.toIso8601String(),
      'timeTo': timeTo?.toIso8601String(),
      'status': status,
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
