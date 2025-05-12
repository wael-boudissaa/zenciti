import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenciti/features/activity/domain/entities/activity.dart';
import 'package:zenciti/features/activity/domain/usecase/activity_single_use_case.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_event.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_type_bloc.dart';

class ActivitySingleBloc extends Bloc<ActivityEvent, ActivityState> {
  final ActivitySingleUseCase activityUseCase;

  ActivitySingleBloc(this.activityUseCase) : super(ActivityInitials()) {
    on<GetActivityById>(_onActivityGetById);
  }

  Future<void> _onActivityGetById(
    GetActivityById event,
    Emitter<ActivityState> emit,
  ) async {
    emit(ActivityLoading());

    try {
      final activities = await activityUseCase.execute(event.idActivity);

      log("Fetched Activities: $activities");

      // Emit success state with the fetched activities
      emit(ActivitySuccess([activities])); // wrap in a list
    } catch (e, stackTrace) {
      log("Error fetching activities", error: e, stackTrace: stackTrace);
      emit(ActivityFailure(e.toString()));
    }
  }
}
