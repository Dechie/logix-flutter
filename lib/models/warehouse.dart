class Warehouse {
  Warehouse({
    required this.name,
    required this.address,
  });
  final String address;
  final String name;

  factory Warehouse.fromMap(Map<String, dynamic> map) {
    return Warehouse(
      name: map['name'],
      address: map['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': address,
      
    };
  }
}
