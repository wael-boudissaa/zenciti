import 'package:flutter_bloc/flutter_bloc.dart';
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
      await restaurantUseCase.OrderFood(event.idOrder, event.food);
      emit(OrderSuccess("Order placed successfully"));
    } catch (e) {
      emit(RestaurantFailure(e.toString()));
    }
  }
}
