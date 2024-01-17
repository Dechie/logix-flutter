import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logixx/screens/commons.dart';
import 'package:logixx/screens/driver/subscreens/apply_company.dart';
import 'package:logixx/screens/driver/subscreens/truck_screen.dart';

import '../../models/driver.dart';
import '../../models/auth_user.dart';
import '../../utils/constants.dart';

// ignore: must_be_immutable
class DriverMainPage extends StatefulWidget {
  DriverMainPage({
    super.key,
    required this.driver,
    this.usersList,
  });

  final Driver driver;
  List<AuthedUser>? usersList;
  @override
  _DriverMainPageState createState() => _DriverMainPageState();
}

class _DriverMainPageState extends State<DriverMainPage> {
  Widget? activeScreen;
  var applyCompanyScreen, truckScreen, orderScreen, travelsScreen;

  List<Widget> subScreens = [];
  bool _moreAccountsTabSelected = true;
  final commons = CommonMethos();

  void switchScreen(int screenId) {
    setState(() {
      activeScreen = subScreens[screenId];
    });
  }

  @override
  void initState() {
    super.initState();
    truckScreen = MyTruckScreen(driver: widget.driver);
    applyCompanyScreen = ApplyCompany(driver: widget.driver);
    orderScreen = ApplyCompany(driver: widget.driver);
    travelsScreen = applyCompanyScreen;
    subScreens = [
      applyCompanyScreen,
      truckScreen,
      orderScreen,
      travelsScreen,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final driver = widget.driver;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Logix Driver Page',
          style: GoogleFonts.roboto(),
        ),
      ),
      body: activeScreen,
      // TODO: add body here
      drawer: Drawer(
        backgroundColor: GlobalConstants.mainBlue,
        width: MediaQuery.of(context).size.width * .72,
        child: SingleChildScrollView(
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
                      driver.name,
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: GlobalConstants.mainBlue,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          driver.phone,
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: GlobalConstants.mainBlue,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                _moreAccountsTabSelected =
                                    !_moreAccountsTabSelected;
                              });
                            },
                            icon: const Icon(Icons.arrow_drop_down)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (_moreAccountsTabSelected)
                commons.showMoreAccounts(context, widget.usersList!),
              ListTile(
                title: Text(
                  'MyCompany',
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
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
                  'My Truck',
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
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
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
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
                  'travels',
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: () {
                  switchScreen(3);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
