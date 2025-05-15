import 'package:equatable/equatable.dart';

abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();

  @override
  List<Object> get props => [];
}

class RestaurantTableGetAll extends RestaurantEvent {
  final String idRestaurant;
  const RestaurantTableGetAll({
    required this.idRestaurant,
  });
}

class RestaurantGetAll extends RestaurantEvent {
  const RestaurantGetAll();
}
class RestaurantGetById extends RestaurantEvent {
  final String id;
  const RestaurantGetById({
    required this.id,
  });
}
