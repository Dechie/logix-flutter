class AuthedUser {
  final String name;
  final String email;
  final String role;
  final String token;
  String? password;

  AuthedUser({
    required this.name,
    required this.role,
    required this.token,
    required this.email,
    this.password,
  });

  factory AuthedUser.fromMap(Map<String, dynamic> json) {
    return AuthedUser(
      name: json['name'],
      email: json['email'],
      role: json['role'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'token': token,
    };
  }
}
