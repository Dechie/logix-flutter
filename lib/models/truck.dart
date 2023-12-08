import 'package:logixx/models/driver.dart';

class Truck {
  const Truck({
    required this.id,
    required this.name,
    required this.driver,
    required this.fuelConsumption,
    required this.mileage,
    required this.companyId,
    required this.createAt,
    required this.updatedAt,
  });
  final int id;
  final Driver driver;
  final double mileage;
  final int companyId;
  final double fuelConsumption;
  final String createAt;
  final String updatedAt;
  final String name;

  factory Truck.fromMap(Map<String, dynamic> map) {
    return Truck(
      id: map['id'] as int,
      name: map['name'] as String,
      driver: Driver.fromMap(map['driver']),
      fuelConsumption: map['fuel_consumption'] as double,
      mileage: map['mileage'] as double,
      companyId: map['id'] as int,
      createAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'driver': driver,
      'fuelConsumption': fuelConsumption,
      'companyId': id,
    };
  }
}
