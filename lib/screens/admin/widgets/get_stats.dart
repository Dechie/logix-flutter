import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../../models/stock.dart';

class GetStats extends StatefulWidget {
  GetStats({Key? key}) : super(key: key);

  @override
  _GetStatsState createState() => _GetStatsState();
}

class _GetStatsState extends State<GetStats> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height * .6,
      child: const Center(
        child: Text('chart'),
      ),
    );
  }
}
