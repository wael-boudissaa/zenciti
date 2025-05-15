class User {
  final String firstName;
  final String password;
  final String lastName;
  final String email;
  final String address;
  final String phone;
  User({required this.firstName, required this.password, required this.address, required this.phone,required this.lastName, required this.email});
}

class LoginUser {
    final String email;
    final String password;
    LoginUser({required this.email, required this.password});
    


}

