import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../../models/shipment.dart';

class GetStats extends StatefulWidget {
  GetStats({Key? key}) : super(key: key);

  @override
  _GetStatsState createState() => _GetStatsState();
}

class _GetStatsState extends State<GetStats> {
  @override
  Widget build(BuildContext context) {
    final List<Shipment> data = [
      Shipment(
        quantity: 2008,
        payment: 10000000,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue),
      ),
      Shipment(
        quantity: 2009,
        payment: 11000000,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue),
      ),
      Shipment(
        quantity: 2010,
        payment: 12000000,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue),
      ),
      Shipment(
        quantity: 2011,
        payment: 10000000,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue),
      ),
      Shipment(
        quantity: 2012,
        payment: 8500000,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue),
      ),
      Shipment(
        quantity: 2013,
        payment: 7700000,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue),
      ),
      Shipment(
        quantity: 2014,
        payment: 7600000,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue),
      ),
      Shipment(
        quantity: 2015,
        payment: 5500000,
        barColor: charts.ColorUtil.fromDartColor(Colors.red) as charts.Color,
      ),
    ];

    List<charts.Series<Shipment, String>> _createSeries() {
      return [
        charts.Series<Shipment, String>(
          id: 'Shipments',
          data: data,
          domainFn: (Shipment shipment, _) => shipment.quantity.toString(),
          measureFn: (Shipment shipment, _) => shipment.payment,
          colorFn: (Shipment shipment, _) => shipment.barColor,
          labelAccessorFn: (Shipment shipment, _) => '${shipment.payment}',
        ),
      ];
    }

    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height * .6,
      child: Center(
        child: charts.BarChart(
          _createSeries(),
          animate: true,
        ),
      ),
    );
  }
}
