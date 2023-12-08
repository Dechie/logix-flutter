import 'package:logixx/models/staff.dart';

import 'driver.dart';

class OrderReciept {
  const OrderReciept({
    required this.id,
    required this.name,
    required this.companyId,
    required this.driver,
    required this.staff,
    required this.deliveredTime,
    required this.createAt,
    required this.updatedAt,
  });
  final int id;
  final int companyId;
  final Driver driver;
  final Staff staff;
  final String deliveredTime;
  final String createAt;
  final String updatedAt;
  final String name;

  factory OrderReciept.fromMap(Map<String, dynamic> map) {
    return OrderReciept(
      id: map['id'] as int,
      name: map['name'] as String,
      driver: Driver.fromMap(map['driver']),
      staff: Staff.fromMap(map['staff']),
      deliveredTime: map['delivered_time'],
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
      'staff': staff,
      'delivered_time': deliveredTime,
      'companyId': id,
    };
  }
}
