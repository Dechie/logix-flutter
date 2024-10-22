import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logixx/screens/admin/main/subscreens/assign_warehouse.dart';
import 'package:logixx/services/api/tenant/tenant_api.dart';
import 'package:logixx/utils/constants.dart';

import '../../../../models/admin.dart';
import '../../../../models/company.dart';
import '../../../../models/driver.dart';
import '../../../../models/staff.dart';
import '../../../../models/warehouse.dart';

class EmployeesWidget extends StatefulWidget {
  const EmployeesWidget({
    super.key,
    required this.admin,
    required this.company,
    required this.title,
    required this.scaffoldKey,
  });

  final Admin admin;
  final Company company;
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<EmployeesWidget> createState() => _EmployeesWidgetState();
}

class _EmployeesWidgetState extends State<EmployeesWidget>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Staff> staffs = [];
  List<Driver> drivers = [];
  List<Warehouse> warehouses = [];
  final tenantApi = TenantApi();

  var empType = 'staff';

  void onAssignWarehouse(Staff staff) async {
    late int statusCode;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * .65,
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: ListView.separated(
                itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    // TODO: function to assign warehouse to employee
                  },
                  leading: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(warehouses[index].name),
                      Text(warehouses[index].location),
                    ],
                  ),
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: warehouses.length,
              ),
            ),
          ],
        ),
      ),
    );

    //return 300;
  }

  void refresh() async {
    //fetchWarehouses(widget.company.companyId!);
    switch (empType) {
      case "staff":
        fetchStaffs(widget.company.companyId!);
        break;
      case "driver":
        fetchDrivers(widget.company.companyId!);
        break;
    }
  }

  void fetchDrivers(int tenantId) async {
    int statusCode = 0;
    List<Driver> fetched = [];
    fetched = await tenantApi.fetchDrivers(tenantId, widget.admin);
    if (fetched.isNotEmpty) {
      setState(() {
        drivers = fetched;
      });
    }
  }

  void fetchStaffs(int tenantId) async {
    int statusCode = 0;
    List<Staff> fetched = [];
    fetched = await tenantApi.fetchStaffs(tenantId, widget.admin);
    if (fetched.isNotEmpty) {
      setState(() {
        staffs = fetched;
      });
    }
  }

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    fetchDrivers(widget.company.companyId!);
    fetchStaffs(widget.company.companyId!);
    _tabController = TabController(length: 2, vsync: this);
  }

  final _tabs = [
    //const Tab(text: 'Staff'),
    //const Tab(text: 'Water'),
    const Tab(text: 'Staffs'),
    const Tab(text: 'Drivers'),
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () => widget.scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: onRefresh,
        //     icon: const Icon(
        //       Icons.refresh,
        //       color: GlobalConstants.mainBlue,
        //     ),
        //   ),
        // ],
        flexibleSpace: SizedBox(
          height: double.infinity,
          width: 20,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              gradient: LinearGradient(
                colors: [
                  GlobalConstants.mainBlue,
                  GlobalConstants.mainBlue.withOpacity(.85),
                  GlobalConstants.mainBlue.withOpacity(.45),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      ),
      body: SizedBox(
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
              onTap: (value) {
                if (value == 0) {
                  empType = "staff";
                } else if (value == 1) {
                  empType = "driver";
                }
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: [
                StaffList(
                  staff: staffs,
                  company: widget.company,
                  admin: widget.admin,
                ),
                DriversList(drivers: drivers),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

class StaffList extends StatelessWidget {
  const StaffList({
    super.key,
    required this.staff,
    required this.company,
    required this.admin,
  });

  final List<Staff> staff;
  final Company company;
  final Admin admin;
  @override
  Widget build(BuildContext context) {
    return staff.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: ListView.separated(
                itemCount: staff.length,
                itemBuilder: (ctx, index) => Card(
                  elevation: 5,
                  shadowColor: const Color.fromARGB(255, 33, 47, 243),
                  child: ListTile(
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 0,
                          child: Text('Assign Warehouse'),
                        ),
                      ],
                      onSelected: (value) {
                        switch (value) {
                          case 0:
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AssignWarehouseWidget(
                                  staff: staff[index],
                                  company: company,
                                  admin: admin,
                                ),
                              ),
                            );
                        }
                      },
                    ),
                    title: Text(
                      staff[index].name,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                        ),
                        Text(
                          staff[index].phone,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
              ),
            ),
          )
        : const Center(
            child: Text('No staffs so far'),
          );
  }
}

class DriversList extends StatelessWidget {
  const DriversList({
    super.key,
    required this.drivers,
  });

  final List<Driver> drivers;
  @override
  Widget build(BuildContext context) {
    return drivers.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: ListView.separated(
                itemCount: drivers.length,
                itemBuilder: (ctx, index) => Card(
                  elevation: 5,
                  shadowColor: const Color.fromARGB(255, 33, 47, 243),
                  child: ListTile(
                    title: Text(
                      drivers[index].name,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        const Icon(Icons.location_on),
                        Text(
                          drivers[index].phone,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
              ),
            ),
          )
        : Center(
            child: Text('No drivers so far'),
          );
  }
}
