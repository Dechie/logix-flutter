import 'auth_user.dart';

class Driver {
  final String name;
  final String phone;
  String? password;
  String? token;
  int? id;

  Driver({
    required this.name,
    required this.phone,
    this.password,
    this.token,
    this.id,
  });
  factory Driver.fromAuthedUser(AuthedUser user) {
    return Driver(
      id: user.id,
      name: user.name,
      phone: user.phone,
      token: user.token,
    );
  }

  factory Driver.fromMap(Map<String, dynamic> map) {
    return Driver(
      name: map['name'] as String,
      phone: map['phone'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': name,
    };
  }
}
