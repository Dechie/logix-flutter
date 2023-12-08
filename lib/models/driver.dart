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

  factory Driver.fromMap(Map<String, dynamic> map) {
    return Driver(
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': name,
    };
  }
}
