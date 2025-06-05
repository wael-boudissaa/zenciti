class LoginEvent {
    LoginEvent();
}


class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  LoginSubmitted({required this.email, required this.password});
}
class UsernamePrefixChanged extends LoginEvent {
  final String prefix;

  UsernamePrefixChanged({required this.prefix});
}


