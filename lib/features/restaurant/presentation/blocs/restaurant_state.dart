part of 'restaurant_table_bloc.dart';

abstract class RestaurantState<T> {}

class RestaurantInitials<T> extends RestaurantState<T> {}

class RestaurantLoading<T> extends RestaurantState<T> {}

class RestaurantSuccess<T> extends RestaurantState<T> {
  final List<T> restaurant;

  RestaurantSuccess(this.restaurant);
}

class RestaurantSingleSuccess<T> extends RestaurantState<T> {
  final Restaurant restaurant;

  RestaurantSingleSuccess(this.restaurant);
}

class RestaurantFailure<T> extends RestaurantState<T> {
  final String error;

  RestaurantFailure(this.error);
}

class MenuSuccess<T> extends RestaurantState<T> {
  final List<MenuItem> menu;

  MenuSuccess(this.menu);
}

class OrderSuccess<T> extends RestaurantState<T> {
  final String message;

  OrderSuccess(this.message);
}

class ReservationSuccess<T> extends RestaurantState<T> {
  final String message;
  final String reservationId;

  ReservationSuccess(this.message, this.reservationId);
}
