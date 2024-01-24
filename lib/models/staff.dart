import 'auth_user.dart';

class Staff {
  final String name;
  final String phone;
  String? password;
  String? token;
  int? id;

  Staff({
    required this.name,
    required this.phone,
    this.password,
    this.id,
    this.token,
  });
  factory Staff.fromAuthedUser(AuthedUser user) {
    return Staff(
      id: user.id,
      name: user.name,
      phone: user.phone,
      token: user.token,
    );
  }

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      name: map['name'] as String,
      phone: map['phone'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
    };
  }
}
