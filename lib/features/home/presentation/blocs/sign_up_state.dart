// features/auth/presentation/bloc/sign_up_state.dart
part of 'auth_bloc.dart';

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpFailure extends SignUpState {
  final String error;

  SignUpFailure(this.error);
}

class GetClientSuccess extends SignUpState {
  final User user;

  GetClientSuccess(this.user);
}
