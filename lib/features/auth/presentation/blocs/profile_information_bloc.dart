import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenciti/features/auth/domain/entities/user.dart';
import 'package:zenciti/features/auth/domain/repositories/notification_repo.dart';
import 'package:zenciti/features/auth/domain/usecase/friend_request_use_case.dart';
import 'package:zenciti/features/auth/domain/usecase/register_use_case.dart';
import 'package:zenciti/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:zenciti/features/auth/presentation/blocs/notification_state.dart';
import 'package:zenciti/features/auth/presentation/blocs/sign_up_event.dart';

class ProfileInformationBloc extends Bloc<SignUpEvent, SignUpState> {
  final RegisterUseCase registerUseCase;

  ProfileInformationBloc(this.registerUseCase) : super(SignUpInitial()) {
    on<GetProfileData>(_onGetProfileData);
  }

  Future<void> _onGetProfileData(
    GetProfileData event,
    Emitter<SignUpState> emit,
  ) async {
    emit(SignUpLoading());

    try {
      // Call the use case to get user profile data
      final userProfile = await registerUseCase.getUserProfile(event.idClient);

      // Emit success state with user profile data
      emit(ProfileInformationSuccess(userProfile));
    } catch (e) {
      // Emit failure state with error message
      emit(SignUpFailure(e.toString()));
      throw e; // Rethrow the error for further handling if needed
    } catch (e) {
      emit(SignUpFailure(
          'An unexpected error occurred: ${e.toString()}')); // Emit failure state with error message
    }
  }
}
