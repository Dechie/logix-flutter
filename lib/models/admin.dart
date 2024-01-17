import 'package:logixx/models/auth_user.dart';

class Admin {
  final String name;
  final String phone;
  String? password;
  String? token;

  Admin({
    required this.name,
    required this.phone,
    this.password,
    this.token,
  });

  factory Admin.fromMap(Map<String, dynamic> json) {
    return Admin(
      name: json['name'],
      phone: json['phone'],
    );
  }

  factory Admin.fromAuthedUser(AuthedUser user) {
    return Admin(
      name: user.name,
      phone: user.phone,
      token: user.token,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
    };
  }
}
