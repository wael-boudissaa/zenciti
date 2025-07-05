import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenciti/features/home/domain/usecase/map_use_case.dart';
import 'package:zenciti/features/home/presentation/blocs/map_event.dart';
import 'package:zenciti/features/home/presentation/blocs/map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapUseCase mapUseCase; // ✅ Fixed typo

  MapBloc(this.mapUseCase) : super(MapInitials()) {
    on<MapSubmitted>(_onMapSubmitted);
  }

  Future<void> _onMapSubmitted(
    MapSubmitted event,
    Emitter<MapState> emit,
  ) async {
    emit(MapLoading());

    try {
      final locations =
          await mapUseCase.execute(event.longitude, event.latitude);
      emit(MapSuccess(locations));
    } catch (e) {
      emit(MapFailure(e.toString()));
    }
  }
}
