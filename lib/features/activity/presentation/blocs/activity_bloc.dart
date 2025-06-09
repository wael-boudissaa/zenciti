import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenciti/features/activity/domain/entities/activity.dart';
import 'package:zenciti/features/activity/domain/usecase/ativity_use_case.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_event.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_type_bloc.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final ActivityUseCase activityUseCase;

  ActivityBloc(this.activityUseCase) : super(ActivityInitials()) {
    on<ActivityGet>(_onActivityGetByType);
    on<ActivityRecentGet>(_onActivityRecentGet);
    on<ActivityCreate>(_onActivityCreate);
    on<GetTimeNotAvailable>(_onGetTimeNotAvailable);
  }

  Future<void> _onActivityGetByType(
    ActivityGet event,
    Emitter<ActivityState> emit,
  ) async {
    emit(ActivityLoading());

    log("Activity Type Received: ${event.activityType}");

    try {
      final activities = await activityUseCase.execute(event.activityType);

      log("Fetched Activities: $activities");

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
    } catch (e, stackTrace) {
      log("Error fetching activities", error: e, stackTrace: stackTrace);
      emit(ActivityFailure(e.toString()));
    }
  }

  Future<void> _onActivityRecentGet(
    ActivityRecentGet event,
    Emitter<ActivityState> emit,
  ) async {
    emit(ActivityLoading());

    try {
      final activities = await activityUseCase.executeRecent(event.idClient);

      log("Fetched Recent Activities: $activities");

      // Emit success state with the fetched activities
      emit(ActivitySuccess(
        activities
            .map((activity) => ActivityProfile(
                  idActivity: activity.idActivity,
                  nameActivity: activity.nameActivity,
                  descriptionActivity: activity.descriptionActivity,
                  imageActivity: activity.imageActivity,
                  popularity: activity.popularity,
                  timeActivity: activity.timeActivity,
                ))
            .toList(),
      ));
    } catch (e, stackTrace) {
      log("Error fetching recent activities", error: e, stackTrace: stackTrace);
      emit(ActivityFailure(e.toString()));
    }
  }

  Future<void> _onActivityCreate(
    ActivityCreate event,
    Emitter<ActivityState> emit,
  ) async {
    emit(ActivityLoading());

    try {
      await activityUseCase.createActivity(
        event.activityId,
        event.idClient,
        event.timeActivity,
      );

      log("Activity Created: ${event.activityId}");

      // Emit success state with a message
      emit(ActivityCreatedSuccess("Activity created successfully"));
    } catch (e, stackTrace) {
      log("Error creating activity", error: e, stackTrace: stackTrace);
      emit(ActivityFailure(e.toString()));
    }
  }
    Future<void> _onGetTimeNotAvailable(
        GetTimeNotAvailable event,
        Emitter<ActivityState> emit,
    ) async {
        emit(ActivityLoading());
    
        try {
        final listTimeNotAvailable = await activityUseCase.getTimeNotAvailable(
            event.idActivity,
            event.day,
        );
    
        log("Fetched Time Not Available: $listTimeNotAvailable");
    
        // Emit success state with the list of time not available
        emit(TimeSlotNotAvailable(listTimeNotAvailable));
        } catch (e, stackTrace) {
        log("Error fetching time not available", error: e, stackTrace: stackTrace);
        emit(ActivityFailure(e.toString()));
        }
    }
}

