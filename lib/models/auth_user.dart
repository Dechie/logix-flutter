class AuthedUser {
  int? id;
  final String name;
  final String phone;
  final String role;
  final String token;
  String? password;

  AuthedUser({
    required this.name,
    required this.role,
    required this.token,
    required this.phone,
    this.password,
    this.id,
  });

  factory AuthedUser.fromMap(Map<String, dynamic> json) {
    return AuthedUser(
      name: json['name'],
      phone: json['phone'],
      role: json['role'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'role': role,
      'token': token,
    };
  }
}
