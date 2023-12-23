//import 'package:charts_flutter/flutter.dart' as charts;

enum StockType { shipmentIn, shipmentOut }

class Stock {
  Stock({
    //required this.companyId,
    //required this.warehouseId,
    required this.price,
    required this.quantity,
    required this.arrivedDate,
    required this.status,

    //required this.shipType,
  });

  final double price;
  final int quantity;
  //final StockType? shipType;
  final String status;
  final String arrivedDate;
  //final int companyId;
  //final int warehouseId;

  factory Stock.fromMap(Map<String, dynamic> map) {
    double priceD = 0.0;
    priceD += map['price'];
    return Stock(
      //companyId: map['company_id'] as int,
      //warehouseId: map['warehouse_id'] as int,
      quantity: map['quantity'] as int,
      price: priceD,
      arrivedDate: map['arrived_at'] as String,
      status: map['status'] as String,
      //shipType: map['shipment_type'] as StockType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quantity': quantity,
      'price': price,
      'arrived_at': arrivedDate,
      'status': status,
    };
  }
}
