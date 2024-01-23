import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logixx/screens/admin/main/subscreens/company_general.dart';
import 'package:logixx/screens/admin/main/subscreens/employees.dart';

import '../../models/admin.dart';
import '../../models/company.dart';
import '../../models/route.dart';
import '../../utils/constants.dart';
import 'main/subscreens/admin_warehouse.dart';
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
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late Widget activeScreen;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String activeScreenTitle = 'Routes';

  late Widget companyDashboardScreen,
      routeScreen,
      projectScreen,
      generalScreen,
      adminWarehouseScreen,
      employeesScreen;
  List<String> projects = [];
  List<TravelRoute> routes = [];
  late int tenantId;
  late List<dynamic> screenWithIndex;

  void backFunction() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    //scaffoldKey = GlobalKey<ScaffoldState>();
    // companyDashboardScreen = CompanyDashboard(admin: admin);
    //drawer2 = createDrawer();
    // projectScreen = ProjectScreen(
    //   admin: admin,
    //   company: company,
    //   title: 'Projects',
    //   scaffoldKey: scaffoldKey,
    // );
    routeScreen = RouteScreen(
      admin: widget.admin,
      company: widget.company,
      title: 'Routes',
      scaffoldKey: scaffoldKey,
    );
    adminWarehouseScreen = AdminWarehouseScreen(
      admin: widget.admin,
      company: widget.company,
      title: 'Warehouses',
      scaffoldKey: scaffoldKey,
      //drawer: drawer2,
    );
    generalScreen = CompanyGeneral(
      company: widget.company,
      admin: widget.admin,
      title: 'General',
      scaffoldKey: scaffoldKey,
    );

    employeesScreen = EmployeesWidget(
      admin: widget.admin,
      company: widget.company,
      title: 'Employees',
      scaffoldKey: scaffoldKey,
    );

    activeScreen = generalScreen;

    screenWithIndex = [
      generalScreen,
      routeScreen,
      adminWarehouseScreen,
      employeesScreen,
      //companyDashboardScreen,
    ];

    setState(() {});
  }

  void switchScreen(int newScreen, String title) {
    activeScreen = screenWithIndex[newScreen];
    activeScreenTitle = title;
    setState(() {});
  }

  void switcher(BuildContext context, int screen) {
    switchScreen(screen, 'Routes');
    Navigator.pop(context);
  }

  @override
  build(BuildContext context) {
    final admin = widget.admin;
    final company = widget.company;
    String title = widget.title;

    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        backgroundColor: Colors.white,
        width: MediaQuery.of(context).size.width * .6,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              width: double.infinity,
              height: 150,
              decoration: const BoxDecoration(
                color: GlobalConstants.mainBlue,
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
                          color: Colors.white),
                    ),
                  ),
                  Text(
                    '${company.name} id${company.companyId}',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          //color: GlobalConstants.mainBlue,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                'Companies',
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                backFunction();
              },
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
                switchScreen(0, 'General');
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
                switchScreen(1, 'Routes');
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
                switchScreen(2, 'Warehouses');
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
                switchScreen(3, 'Employees');
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
                switchScreen(0, 'Travels');
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
                switchScreen(0, 'Orders');
                Navigator.pop(context);
              },
            ),
            // ListTile(
            //   title: Text(
            //     'Drivers',
            //     style: GoogleFonts.roboto(
            //       textStyle: const TextStyle(
            //         color: Colors.white,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            //   onTap: () {
            //     switchScreen(0, 'Drivers');
            //     Navigator.pop(context);
            //   },
            // ),
            // ListTile(
            //   title: Text(
            //     'Staff',
            //     style: GoogleFonts.roboto(
            //       textStyle: const TextStyle(
            //         color: Colors.white,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            //   onTap: () {
            //     switchScreen(0, 'Staff');
            //     Navigator.pop(context);
            //   },
            // ),
          ],
        ),
      ),
      body: activeScreen,
    );
  }
}

class DetailView extends StatelessWidget {
  const DetailView({
    super.key,
    required this.numValue,
    required this.title,
    required this.sub,
  });

  final int numValue;
  final String title;
  final String sub;

  @override
  build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .8,
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: GlobalConstants.mainBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  numValue.toString(),
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  sub,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          )
        ],
      ),
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
  build(BuildContext context) {
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
