import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenciti/features/activity/domain/entities/activity.dart';
import 'package:zenciti/features/activity/domain/usecase/ativity_type_use_case.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_event.dart';
// import 'package:zenciti/features/home/domain/usecase/ativity_use_case.dart';


part 'activity_state.dart';

class ActivityTypeBloc extends Bloc<ActivityEvent, ActivityState> {
  final ActivityTypeUseCase activityTypeUseCase;

  // Define initial state
  ActivityTypeBloc(this.activityTypeUseCase) : super(ActivityInitials()) {
    on<ActivityTypeGet>(_onActivityTypeGet);
  }

  Future<void> _onActivityTypeGet(
    ActivityTypeGet event,
    Emitter<ActivityState> emit,
  ) async {
    // Show loading spinner
    emit(ActivityLoading());

    try {
      // Fetch activities from the use case
      final activities = await activityTypeUseCase.execute();

      // Debug print to verify what we got from backend
      log("Fetched Activities: $activities");

      // Emit success state with the fetched activities
      emit(ActivitySuccess(
        activities
            .map((activity) => TypeActivity(
                  idTypeActivity: activity.idTypeActivity,
                  nameTypeActivity: activity.nameTypeActivity,
                  imageActivity: activity.imageActivity,
                ))
            .toList(),
      ));
    } catch (e, stackTrace) {
      // Log the error for debugging
      log("Error fetching activities", error: e, stackTrace: stackTrace);

      // Emit failure state with error message
      emit(ActivityFailure(e.toString()));
    }
  }

}
