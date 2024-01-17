import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logixx/screens/admin/main/subscreens/company_general.dart';
import 'package:logixx/screens/admin/main/subscreens/employees.dart';

import '../../models/admin.dart';
import '../../models/company.dart';
import '../../models/route.dart';
import '../../utils/constants.dart';
import 'main/subscreens/admin_warehouse.dart';
import 'main/subscreens/projects_screen.dart';
import 'main/subscreens/routes_screen.dart';

typedef MyFunctionCallback = void Function(BuildContext context, int screen);

class DashBoard extends StatefulWidget {
  const DashBoard({
    super.key,
    required this.title,
    required this.company,
    required this.admin,
  });

  final String title;
  final Company company;
  final Admin admin;
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late Widget activeScreen;

  var projectScreen,
      routeScreen,
      generalScreen,
      adminWarehouseScreen,
      employeesScreen;
  List<String> projects = [];
  List<TravelRoute> routes = [];
  late int tenantId;
  late List<dynamic> screenWithIndex;

  @override
  void initState() {
    super.initState();
    projectScreen = ProjectScreen(
      admin: widget.admin,
      company: widget.company,
    );
    routeScreen = RouteScreen(
      admin: widget.admin,
      company: widget.company,
    );
    adminWarehouseScreen = AdminWarehouseScreen(
      admin: widget.admin,
      company: widget.company,
    );
    generalScreen = CompanyGeneral(
      company: widget.company,
      admin: widget.admin,
    );

    employeesScreen = EmployeesWidget(
      admin: widget.admin,
      company: widget.company,
    );

    activeScreen = projectScreen;

    screenWithIndex = [
      routeScreen,
      projectScreen,
      generalScreen,
      adminWarehouseScreen,
      employeesScreen,
    ];
  }

  void onRefresh() {
    /*
    activeScreen == routeScreen
        ? routeScreen.refresh()
        : projectScreen.refresh();
        */
  }

  void switchScreen(int newScreen) {
    /*
    switch (newScreen) {
      case 0:
        activeScreen = routeScreen;
        break;
      case 1:
        activeScreen = projectScreen;
        break;
    }
    */
    activeScreen = screenWithIndex[newScreen];
    setState(() {});
  }

  void switcher(BuildContext context, int screen) {
    switchScreen(screen);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final admin = widget.admin;
    final company = widget.company;
    String title = widget.title;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: onRefresh,
            icon: const Icon(
              Icons.refresh,
              color: GlobalConstants.mainBlue,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: GlobalConstants.mainBlue,
        width: MediaQuery.of(context).size.width * .6,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              width: double.infinity,
              height: 150,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    admin.name,
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: GlobalConstants.mainBlue,
                      ),
                    ),
                  ),
                  Text(
                    '${company.name} id${company.companyId}',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: GlobalConstants.mainBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                'General',
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                switchScreen(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Routes',
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                switchScreen(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Projects',
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                switchScreen(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Travels',
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                switchScreen(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Orders',
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                switchScreen(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Drivers',
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                switchScreen(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Staff',
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                switchScreen(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Warehouses',
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                switchScreen(3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Employees',
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                switchScreen(4);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: activeScreen,
    );
  }
}

class CustomTile extends StatelessWidget {
  const CustomTile({
    super.key,
    required this.screenSwitcher,
    required this.ctx,
    required this.text,
  });

  final VoidCallback screenSwitcher;
  final BuildContext ctx;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
        style: GoogleFonts.roboto(
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onTap: screenSwitcher,
    );
  }
}
