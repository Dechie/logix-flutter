import 'package:logixx/models/stock.dart';

class Order {
  Order({
    required this.name,
    required this.staffEmail,
    this.stocks,
    this.id,
  });

  final String name;
  final String staffEmail;
  List<Stock>? stocks = [];
  int? id;

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      staffEmail: map['staff_email'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'staff_email': staffEmail,
    };
  }
}
