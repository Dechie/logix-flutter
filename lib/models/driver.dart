import 'auth_user.dart';

class Driver {
  final String name;
  final String email;
  String? password;
  String? token;

  Driver({
    required this.name,
    required this.email,
    this.password,
    this.token,
  });
  factory Driver.fromAuthedUser(AuthedUser user) {
    return Driver(
      name: user.name,
      email: user.email,
      token: user.token,
    );
  }
}
