class TravelRoute {
  TravelRoute({
    required this.name,
    required this.companyId,
  });

  final String name;
  final int companyId;

  factory TravelRoute.fromMap(Map<String, dynamic> map) {
    return TravelRoute(
      name: map['name'] as String,
      companyId: map['company_id'] as int,
    );
  }
}
