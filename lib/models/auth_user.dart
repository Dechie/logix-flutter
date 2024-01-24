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
    int id = 0;
    if (json['id'] is! int) {
      print('it\'s an int');
      String idS = json['id'];
      idS = idS.trimLeft();
      idS = idS.trimRight();
      id = int.parse(idS);
    } else {
      print('it\'s not an int');
      id = json['id'];
    }

    return AuthedUser(
      id: id,
      name: json['name'],
      phone: json['phone'],
      role: json['role'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'role': role,
      'token': token,
    };
  }

  @override
  String toString() {
    return '{"id": $id, "name": "$name", "phone": "$phone", "role": "$role", "token": "$token"}';
  }
}
