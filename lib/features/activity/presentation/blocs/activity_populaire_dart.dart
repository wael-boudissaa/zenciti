import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenciti/features/activity/domain/entities/activity.dart';
import 'package:zenciti/features/activity/domain/usecase/activity_popularity.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_event.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_type_bloc.dart';

class ActivityPopulaireBloc extends Bloc<ActivityEvent, ActivityState> {
  final ActivityPopularityUseCase activityPopularity;

  ActivityPopulaireBloc(this.activityPopularity) : super(ActivityInitials()) {
    on<ActivityPopulaireGet>(_onActivityPopulaireGet);
  }

  Future<void> _onActivityPopulaireGet(
    ActivityPopulaireGet event,
    Emitter<ActivityState> emit,
  ) async {
    try {
      final activities = await activityPopularity.execute();

      // Emit success state with the fetched activities
      emit(ActivitySuccess(
        activities
            .map((activity) => Activity(
                  idActivity: activity.idActivity,
                  nameActivity: activity.nameActivity,
                  descriptionActivity: activity.descriptionActivity,
                  typeActivity: activity.typeActivity,
                  imageActivity: activity.imageActivity,
                  popularity: activity.popularity,
                ))
            .toList(),
      ));
    } catch (error) {
      // Log the error for debugging
      log("Error fetching popular activities", error: error);

      // Emit failure state with error message
      emit(ActivityFailure(error.toString()));
    }
  }
}
