class Terminal {
  const Terminal({
    required this.id,
    required this.name,
    required this.location,
  });
  final int id;
  final String name;
  final String location;

  factory Terminal.fromMap(Map<String, dynamic> map) {
    return Terminal(
      id: map['id'] as int,
      name: map['name'] as String,
      location: map['location'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
    };
  }
}
