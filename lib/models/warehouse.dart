class Warehouse {
  Warehouse({
    required this.name,
    required this.location,
    this.id,
    this.staffId,
  });
  final String location;
  final String name;
  int? id;
  int? staffId;

  factory Warehouse.fromMap(Map<String, dynamic> map) {
    return Warehouse(
      id: map['id'],
      name: map['name'],
      location: map['address'],
      staffId: map['staff_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'staff_id': 0,
    };
  }
}
