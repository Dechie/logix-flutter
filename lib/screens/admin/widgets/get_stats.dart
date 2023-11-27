import 'package:flutter/material.dart';

class GetStats extends StatefulWidget {
  GetStats({Key? key}) : super(key: key);

  @override
  _GetStatsState createState() => _GetStatsState();
}

class _GetStatsState extends State<GetStats> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('Statistics')),
    );
  }
}
