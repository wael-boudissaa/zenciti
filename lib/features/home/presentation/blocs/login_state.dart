
part of 'auth_bloc.dart';

abstract class LoginState {}

class LoginInitials extends LoginState {}
class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
    final String token ; 
    final User user;
    LoginSuccess(this.token, this.user);
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}
