
part of 'auth_bloc.dart';

abstract class LoginState {}

class LoginInitials extends LoginState {}
class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}
class UsernamePrefixLoading extends LoginState {}
class UsernamePrefixSuccess extends LoginState {
  final List<String> usernames;

  UsernamePrefixSuccess(this.usernames);
}
