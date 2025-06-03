import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenciti/features/auth/domain/repositories/notification_repo.dart';
import 'package:zenciti/features/auth/domain/usecase/friend_request_use_case.dart';
import 'package:zenciti/features/auth/presentation/blocs/notification_state.dart';
part 'notification_event.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final FriendRequestUseCase friendRequestUseCase;

  NotificationBloc(this.friendRequestUseCase) : super(NotificationInitial()) {
    on<NotificationGet>(_onNotificationGet);
    on<AcceptRequest>(_onAcceptRequest);
    on<SendRequest>(_onSendRequest);
  }

  Future<void> _onNotificationGet(
    NotificationGet event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());

    try {
      final friendRequestList =
          await friendRequestUseCase.execute(event.idClient);
      emit(NotificationSucces(friendRequestList));
    } catch (e) {
      emit(NotificationFailure(e.toString()));
    } catch (e) {
      emit(NotificationFailure(
          'An unexpected error occurred: ${e.toString()}')); // Emit failure state with error message
    }
  }

  Future<void> _onAcceptRequest(
    AcceptRequest event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await friendRequestUseCase.executeAccept(event.idFriendship);
      emit(AcceptRequestState('Friend request accepted successfully'));
    } catch (e) {
      emit(NotificationFailure(
          'Failed to accept friend request: ${e.toString()}'));
    }
  }

  Future<void> _onSendRequest(
    SendRequest event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await friendRequestUseCase.executeSend(
          event.usernameSender, event.usernameReceiver);
      emit(SendRequestState('Friend request sent successfully'));
    } catch (e) {
      emit(NotificationFailure(
          'Failed to send friend request: ${e.toString()}'));
    }
  }
}
