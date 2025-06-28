class ReservationClient {
  final String idReservation;
  final String timeFrom;
  final int numberOfPeople;
  final String status;
  final String createdAt;
  final String restaurantName;
  final String restaurantImage;
  final String restaurantLocation;
  final String idRestaurant;

  ReservationClient({
    required this.idReservation,
    required this.timeFrom,
    required this.numberOfPeople,
    required this.status,
    required this.createdAt,
    required this.restaurantName,
    required this.restaurantImage,
    required this.restaurantLocation,
    required this.idRestaurant,
  });

  factory ReservationClient.fromJson(Map<String, dynamic> json) {
    return ReservationClient(
      idReservation: json['idReservation'],
      timeFrom: json['timeFrom'],
      numberOfPeople: json['numberOfPeople'],
      status: json['status'],
      createdAt: json['createdAt'],
      restaurantName: json['restaurantName'],
      restaurantImage: json['restaurantImage'],
      restaurantLocation: json['restaurantLocation'], // ✅ fixed here
      idRestaurant: json['idRestaurant'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idReservation': idReservation,
      'timeFrom': timeFrom,
      'numberOfPeople': numberOfPeople,
      'status': status,
      'createdAt': createdAt,
      'restaurantName': restaurantName,
      'restaurantImage': restaurantImage,
      'restaurantLocation': restaurantLocation,
      'idRestaurant': idRestaurant,
    };
  }
}
