import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenciti/features/restaurant/domain/entities/restaurant.dart';
import 'package:zenciti/features/restaurant/domain/usecase/restaurant_table_use_case.dart';
import 'package:zenciti/features/restaurant/domain/usecase/restaurant_use_case.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_event.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_table_bloc.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final RestaurantUseCase restaurantUseCase;

  RestaurantBloc(this.restaurantUseCase) : super(RestaurantInitials()) {
    on<RestaurantGetAll>(_onRestaurantGetAll);
    on<MenuGetFood>(_onMenuGetFood);
    on<RestaurantGetById>(_onRestaurantGetById);
    on<OrderFood>(_onOrderFood);
    on<CreateReservation>(_onCreateReservation);
    on<GetReservationsByClient>(_onReservationClient);
  }

  Future<void> _onRestaurantGetAll(
      RestaurantGetAll event, Emitter<RestaurantState> emit) async {
    emit(RestaurantLoading());
    try {
      final restaurant = await restaurantUseCase.execute();
      // Emit success state with the fetched restaurantTablesUseCase

      emit(RestaurantSuccess(restaurant));
    } catch (e) {
      emit(RestaurantFailure(e.toString()));
    }
  }

  Future<void> _onRestaurantGetById(
      RestaurantGetById event, Emitter<RestaurantState> emit) async {
    emit(RestaurantLoading());
    try {
      final restaurant = await restaurantUseCase.getRestaurantById(event.id);
      emit(RestaurantSingleSuccess(restaurant));
    } catch (e) {
      emit(RestaurantFailure(e.toString()));
    }
  }

  Future<void> _onReservationClient(
      GetReservationsByClient event, Emitter<RestaurantState> emit) async {
    emit(RestaurantLoading());
    try {
      final reservations =
          await restaurantUseCase.getReservationsByClient(event.idClient);
      emit(ReservationClientSuccess(reservations));
    } catch (e) {
      emit(RestaurantFailure(e.toString()));
    }
  }

  Future<void> _onMenuGetFood(
      MenuGetFood event, Emitter<RestaurantState> emit) async {
    emit(RestaurantLoading());
    try {
      final menu = await restaurantUseCase.getMenuActife(event.idRestaurant);
      emit(MenuSuccess(menu));
    } catch (e) {
      emit(RestaurantFailure(e.toString()));
    }
  }

  Future<void> _onOrderFood(
      OrderFood event, Emitter<RestaurantState> emit) async {
    emit(RestaurantLoading());
    try {
      await restaurantUseCase.OrderFood(event.idReservation, event.food);
      emit(OrderSuccess("Order placed successfully"));
    } catch (e) {
      emit(RestaurantFailure(e.toString()));
    }
  }

  Future<void> _onCreateReservation(
      CreateReservation event, Emitter<RestaurantState> emit) async {
    emit(RestaurantLoading());
    try {
      final String response = await restaurantUseCase.createReservation(
        event.idClient,
        event.idRestaurant,
        event.idTable,
        event.timeFrom,
        event.numberOfPeople,
      );
      emit(ReservationSuccess("Reservation created succefuly", response));
    } catch (e) {
      emit(RestaurantFailure(e.toString()));
    }
  }
}

class ReviewsBloc extends Bloc<ReviewsEvent, FriendsReviewState> {
  final RestaurantUseCase restaurantUseCase;

  ReviewsBloc(this.restaurantUseCase) : super(ReviewsInitials()) {
    on<RatingRestaurant>(_onRatingRestaurant);
    on<GetFriendsReviews>(_onGetFriendsReviews);
  }
  Future<void> _onRatingRestaurant(
      RatingRestaurant event, Emitter<FriendsReviewState> emit) async {
    emit(FriendsReviewsLoading());
    try {
      final String response = await restaurantUseCase.ratingRestaurant(
        event.idRestaurant,
        event.idClient,
        event.comment,
        event.rating,
      );
      emit(RatingSucces(response));
    } catch (e) {
      emit(FriendsReviewsFailure(e.toString()));
    }
  }

  Future<void> _onGetFriendsReviews(
      GetFriendsReviews event, Emitter<FriendsReviewState> emit) async {
    emit(FriendsReviewsLoading());
    try {
      final reviews = await restaurantUseCase.getFriendsReviews(
        event.idRestaurant,
        event.idClient,
      );
      emit(FriendsReviewsSuccess(reviews));
    } catch (e) {
      emit(FriendsReviewsFailure(e.toString()));
    }
  }
}
