import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class SignUpEmailChanged extends SignUpEvent {
  final String email;

  const SignUpEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class GetProfileData extends SignUpEvent {
  final String idClient;

  const GetProfileData(this.idClient);
}
class GetUsernameData extends SignUpEvent {
  final String username;

  const GetUsernameData(this.username);
}

class SignUpFirstNameChanged extends SignUpEvent {
  final String firstName;

  const SignUpFirstNameChanged(this.firstName);

  @override
  List<Object?> get props => [firstName];
}

class SignUpLastNameChanged extends SignUpEvent {
  final String lastName;

  const SignUpLastNameChanged(this.lastName);

  @override
  List<Object?> get props => [lastName];
}

class SignUpSubmitted extends SignUpEvent {
  final String email;
  final String firstName;
  final String lastName;
  final String address;
  final String phone;
  final String password;
  final String username;

  const SignUpSubmitted({
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [email, firstName, lastName];
}
