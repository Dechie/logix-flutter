import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logixx/models/admin.dart';
import 'package:logixx/models/auth_user.dart';
import 'package:logixx/screens/admin/admin_main.dart';
import 'package:logixx/screens/auth_page.dart';
import 'package:logixx/screens/warehouse/warehouse_main.dart';
import 'package:logixx/screens/warehouse/warehouse_suspend.dart';
import 'package:logixx/services/shared_prefs.dart';

import '../models/driver.dart';
import '../models/staff.dart';
import '../services/auth.dart';
import 'driver/driver_main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final auth = Auth();
  final preffs = SharedPrefs();
  late Admin admin;
  late Staff staff;
  late Driver driver;
  late AuthedUser authedUser;

  late Widget nextScreen;

  bool isLoggedIn = false;

  void checkLoggedIn() async {
    List<AuthedUser> users = await preffs.getAuthedFromPrefs();

    // since this will mean authedUser will be null
    if (users.isNotEmpty) {
      authedUser = users.last;
      isLoggedIn = true;
    } else {
      isLoggedIn = false;
    }

    //isLoggedIn = authedUser != null;

    if (isLoggedIn) {
      switch (authedUser.role) {
        case 'admin':
          {
            admin = Admin.fromAuthedUser(authedUser);
            nextScreen = AdminMainPage(admin: admin, usersList: users);
          }
          break;
        case 'staff':
          {
            staff = Staff.fromAuthedUser(authedUser);
            nextScreen = WarehouseSuspendPage(staff: staff, usersList: users);
          }
          break;
        case 'driver':
          {
            driver = Driver.fromAuthedUser(authedUser);
            nextScreen = DriverMainPage(driver: driver, usersList: users);
          }
          break;
      }
      setState(() {});
    }
  }

  void navigate(Admin admin) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => AdminMainPage(admin: admin),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    //checkUserAuth();
    return Scaffold(
      body: AnimatedSplashScreen(
        duration: 3000,
        curve: Curves.bounceIn,
        splash: SvgPicture.asset(
          'assets/blob.svg',
          width: 300,
          height: 300,
        ),
        nextScreen: isLoggedIn ? nextScreen : const AuthPage(),
      ),
    );
  }
}
