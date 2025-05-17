import 'package:equatable/equatable.dart';
import 'package:zenciti/features/restaurant/domain/entities/menu.dart';

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

class MenuGetFood extends RestaurantEvent {
  final String idRestaurant;
  const MenuGetFood({
    required this.idRestaurant,
  });
}

class OrderFood extends RestaurantEvent {
  final String idOrder;
  final List<FoodItem> food;
  const OrderFood({
    required this.idOrder,
    required this.food,
  });
}
