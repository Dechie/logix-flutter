import 'package:logixx/models/auth_user.dart';

class Admin {
  final String name;
  final String email;
  String? password;
  String? token;

  Admin({
    required this.name,
    required this.email,
    this.password,
    this.token,
  });

  factory Admin.fromMap(Map<String, dynamic> json) {
    return Admin(
      name: json['name'],
      email: json['email'],
    );
  }

  factory Admin.fromAuthedUser(AuthedUser user) {
    return Admin(
      name: user.name,
      email: user.email,
      token: user.token,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }
}
