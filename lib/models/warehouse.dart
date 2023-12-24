class Warehouse {
  Warehouse({
    required this.name,
    required this.location,
  });
  final String location;
  final String name;

  factory Warehouse.fromMap(Map<String, dynamic> map) {
    return Warehouse(
      name: map['name'],
      location: map['location'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
    };
  }
}
