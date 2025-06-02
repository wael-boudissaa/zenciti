class User {
  final String firstName;
  final String password;
  final String lastName;
  final String email;
  final String address;
  final String phone;
  final String username;
  User(
      {required this.firstName,
      required this.username,
      required this.password,
      required this.address,
      required this.phone,
      required this.lastName,
      required this.email});
  @override
  String toString() {
    return 'User{firstName: $firstName, lastName: $lastName, email: $email, address: $address, phone: $phone, username: $username}';
  }

  @override
  List<Object?> get props =>
      [firstName, lastName, email, address, phone, username];
}

class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String address;
  final String phone;
  final String username;
  final int following;
  final int followers;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address,
    required this.phone,
    required this.username,
    required this.following,
    required this.followers,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      address: json['address'],
      phone: json['phone'],
      username: json['username'],
      following: json['following'] ?? 0,
      followers: json['followers'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'address': address,
      'phone': phone,
      'username': username,
      'following': following,
      'followers': followers,
    };
  }
}

class LoginUser {
  final String email;
  final String password;
  LoginUser({required this.email, required this.password});
}

class UserRegister {
  final String firstName;
  final String lastName;
  final String email;
  final String address;
  final String phone;
  final String password;

  UserRegister({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address,
    required this.phone,
    required this.password,
  });
}
