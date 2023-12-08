import 'package:flutter/material.dart';
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
}
