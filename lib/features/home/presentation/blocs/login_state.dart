
part of 'auth_bloc.dart';

abstract class LoginState {}

class LoginInitials extends LoginState {}
class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
    LoginSuccess();
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}
