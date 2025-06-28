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
class ReservationClientSuccess<T> extends RestaurantState<T> {
    final List<ReservationClient> reservations;

  ReservationClientSuccess(this.reservations);
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

abstract class FriendsReviewState<T> {}
class FriendsReviewsSuccess<T> extends FriendsReviewState<T> {
  final List<ReviewProfile> reviews;

  FriendsReviewsSuccess(this.reviews);

}

class RatingSucces <T> extends FriendsReviewsSuccess<T> {
  final String message;

    RatingSucces(this.message) : super([]);
}


class ReviewsInitials<T> extends FriendsReviewState<T> {}
class FriendsReviewsFailure<T> extends FriendsReviewState<T> {
  final String error;

  FriendsReviewsFailure(this.error);
}

class FriendsReviewsLoading<T> extends FriendsReviewState<T> {}

// This file defines the various states for the Restaurant feature in a Flutter application.


