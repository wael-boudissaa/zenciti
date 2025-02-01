// features/auth/presentation/bloc/sign_up_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenciti/features/auth/domain/entities/user.dart';
import 'package:zenciti/features/auth/domain/usecase/register_use_case.dart';
import 'sign_up_event.dart';
part 'sign_up_state.dart';
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final RegisterUseCase registerUseCase;

  SignUpBloc(this.registerUseCase) : super(SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
  }

  Future<void> _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    emit(SignUpLoading()); // Show loading state

    try {
      // Create a User entity
      final user = User(
        email: event.email,
        firstName: event.firstName,
        lastName: event.lastName,
        address: event.address,
        phone: event.phone,
        password: event.password,
      );

      // Call the use case
      await registerUseCase.execute(user);

      // If successful, emit SignUpSuccess
      emit(SignUpSuccess());
    } catch (e) {
      // If an error occurs, emit SignUpFailure
      emit(SignUpFailure(e.toString()));
    }
  }
}
