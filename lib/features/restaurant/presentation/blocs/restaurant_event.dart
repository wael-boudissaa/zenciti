import 'package:equatable/equatable.dart';
import 'package:zenciti/features/restaurant/domain/entities/menu.dart';

abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();

  @override
  List<Object> get props => [];
}

// restaurant_event.dart
class RestaurantTableGetAll extends RestaurantEvent {
  final String idRestaurant;
  final DateTime timeSlot;

  RestaurantTableGetAll({required this.idRestaurant, required this.timeSlot});
}

class RestaurantGetAll extends RestaurantEvent {
  const RestaurantGetAll();
}

class CreateReservation extends RestaurantEvent {
  final String idClient;
  final String idRestaurant;
  final String idTable;
  final DateTime timeFrom;
  final DateTime? timeTo;
  final int numberOfPeople;

  const CreateReservation({
    required this.idClient,
    required this.idRestaurant,
    required this.idTable,
    required this.timeFrom,
    this.timeTo,
    required this.numberOfPeople,
  });
}

class RestaurantGetById extends RestaurantEvent {
  final String id;
  const RestaurantGetById({
    required this.id,
  });
}

class MenuGetFood extends RestaurantEvent {
  final String idRestaurant;
  const MenuGetFood({
    required this.idRestaurant,
  });
}

class OrderFood extends RestaurantEvent {
  final String idReservation;
  final List<FoodItem> food;
  const OrderFood({
    required this.idReservation,
    required this.food,
  });
}

abstract class ReviewsEvent extends Equatable {
  const ReviewsEvent();

  @override
  List<Object> get props => [];
}

class RatingRestaurant extends ReviewsEvent {
  final String idRestaurant;
  final String idClient;
  final int rating;
  final String comment;

  const RatingRestaurant({
    required this.idRestaurant,
    required this.idClient,
    required this.rating,
    required this.comment,
  });
}

class GetFriendsReviews extends ReviewsEvent {
  final String idRestaurant;
  final String idClient;

  const GetFriendsReviews({
    required this.idRestaurant,
    required this.idClient,
  });
}

class GetReservationsByClient extends RestaurantEvent {
  final String idClient;

  const GetReservationsByClient({
    required this.idClient,
  });
}
