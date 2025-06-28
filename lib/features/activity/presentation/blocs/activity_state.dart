part of 'activity_type_bloc.dart';

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

class ActivityCreatedSuccess<T> extends ActivityState<T> {
  final String idClientActivity;

  ActivityCreatedSuccess(this.idClientActivity);
}

class TimeSlotNotAvailable<T> extends ActivityState<T> {
  final List<String> listTimeNotAvailable;

  TimeSlotNotAvailable(this.listTimeNotAvailable);
}
class ActivityCompleted<T> extends ActivityState<T> {
  final String message;

  ActivityCompleted(this.message);
}

