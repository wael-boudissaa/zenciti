part of 'activity_bloc.dart';

abstract class ActivityState<T> {}

class ActivityInitials<T> extends ActivityState<T> {}

class ActivityLoading<T> extends ActivityState<T> {}

class ActivitySuccess<T> extends ActivityState<T> {
  final List<T> activities;

  ActivitySuccess(this.activities);
}

class ActivityFailure<T> extends ActivityState<T> {
  final String error;

  ActivityFailure(this.error);
}
