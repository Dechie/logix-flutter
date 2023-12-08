class Project {
  const Project({
    required this.id,
    required this.name,
    required this.companyId,
    required this.createAt,
    required this.updatedAt,
  });
  final int id;
  final int companyId;
  final String createAt;
  final String updatedAt;
  final String name;

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] as int,
      name: map['name'] as String,
      companyId: map['id'] as int,
      createAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
