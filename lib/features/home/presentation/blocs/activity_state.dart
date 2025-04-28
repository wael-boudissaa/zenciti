part of 'activity_bloc.dart';
abstract class ActivityState {}

class ActivityInitials extends ActivityState {}

class ActivityLoading extends ActivityState {
}

class ActivitySucces extends ActivityState {
      final List<TypeActivity> activities;

  ActivitySucces(this.activities);
}

class AcitivityFailure extends ActivityState {
  final String error;

  AcitivityFailure(this.error);
}
