class Company {
  Company({
    required this.name,
    this.companyId,
  });

  final String name;
  int? companyId;

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      name: map['name'] as String,
      companyId: map['id'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
