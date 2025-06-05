import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenciti/features/restaurant/domain/entities/menu.dart';
import 'package:zenciti/features/restaurant/domain/entities/reviews.dart';
import 'package:zenciti/features/restaurant/domain/entities/tables.dart';
import 'package:zenciti/features/restaurant/domain/usecase/restaurant_table_use_case.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_event.dart';

part 'restaurant_state.dart';

class RestaurantTableBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final RestaurantTablesUseCase restaurantTablesUseCase;

  RestaurantTableBloc(this.restaurantTablesUseCase)
      : super(RestaurantInitials()) {
    on<RestaurantTableGetAll>(_onRestaurantTableGetAll);
  }

  Future<void> _onRestaurantTableGetAll(
    RestaurantTableGetAll event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(RestaurantLoading());
    try {
      final restaurantTables = await restaurantTablesUseCase.execute(
          event.idRestaurant, event.timeSlot);
      emit(RestaurantSuccess(restaurantTables));
    } catch (e) {
      emit(RestaurantFailure(e.toString()));
    }
  }
}
