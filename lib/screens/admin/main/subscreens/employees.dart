import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logixx/utils/constants.dart';

import '../../../../models/admin.dart';

class EmployeesWidget extends StatefulWidget {
  const EmployeesWidget({
    super.key,
    required this.admin,
  });

  final Admin admin;

  @override
  State<EmployeesWidget> createState() => _EmployeesWidgetState();
}

class _EmployeesWidgetState extends State<EmployeesWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final _tabs = [
    //const Tab(text: 'Staff'),
    //const Tab(text: 'Water'),
    const Tab(text: 'tab'),
    const Tab(text: 'one'),
  ];

  final _tabs2 = [
    const Tab(text: 'tab'),
    const Tab(text: 'two'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Column(
        children: [
          TabBar(
            tabs: _tabs,
            controller: _tabController,
            labelColor: GlobalConstants.mainBlue.withAlpha(200),
            indicatorColor: GlobalConstants.mainBlue.withAlpha(200),
            labelStyle: GoogleFonts.roboto(
              textStyle: const TextStyle(fontSize: 18),
            ),
            unselectedLabelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: GlobalConstants.mainBlue.withOpacity(0.2),
              border: Border.all(
                width: 1,
                color: GlobalConstants.mainBlue.withOpacity(0.4),
              ),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
              child: TabBarView(
            controller: _tabController,
            children: const [
              Center(
                child: Text('Tab 1'),
              ),
              Center(
                child: Text('Tab 2'),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
