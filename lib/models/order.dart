import 'package:logixx/models/stock.dart';

class Order {
  Order({
    required this.name,
    required this.staffPhone,
    this.stocks,
    this.id,
  });

  final String name;
  final String staffPhone;
  List<Stock>? stocks = [];
  int? id;

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      staffPhone: map['staff_phone'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'staff_phone': staffPhone,
    };
  }
}
