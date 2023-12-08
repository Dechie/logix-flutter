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

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }
}
