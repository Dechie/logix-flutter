import 'auth_user.dart';

class Staff {
  final String name;
  final String email;
  String? password;
  String? token;

  Staff({
    required this.name,
    required this.email,
    this.password,
    this.token,
  });
  factory Staff.fromAuthedUser(AuthedUser user) {
    return Staff(
      name: user.name,
      email: user.email,
      token: user.token,
    );
  }
}
