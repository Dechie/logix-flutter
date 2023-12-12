import 'package:charts_flutter/flutter.dart' as charts;

enum ShipmentType { shipmentIn, shipmentOut }

class Shipment {
  Shipment({
    required this.payment,
    required this.quantity,
    this.shipType,
    required this.barColor,
  });

  final double payment;
  final int quantity;
  final charts.Color barColor;
  final ShipmentType? shipType;

  factory Shipment.fromMap(Map<String, dynamic> map) {
    return Shipment(
      payment: map['payment'] as double,
      quantity: map['quantity'] as int,
      barColor: map['bar_color'], // remove this soon
      shipType: map['shipment_type'] as ShipmentType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'payment': payment,
      'quantity': quantity,
      'bar_color': barColor,
      'shipment_type': shipType,
    };
  }
}
