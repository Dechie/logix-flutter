import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/admin.dart';
import '../../models/auth_user.dart';
import '../../models/driver.dart';
import '../../models/staff.dart';
import '../../services/auth.dart';
import '../../services/shared_prefs.dart';

import 'package:logixx/screens/admin/main/admin_main.dart';
import 'package:logixx/screens/driver/driver_main.dart';
import 'package:logixx/screens/warehouse/main/warehouse_main.dart';

import '../../utils/constants.dart';

enum UserRole { admin, staff, driver }

class LoginScreen extends StatefulWidget {
  LoginScreen({
    super.key,
    required this.changePage,
  });

  final VoidCallback changePage;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  //final emailController = TextEditingController();
  final companyCodeController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  var _userRole = UserRole.admin;

  late bool _userIsAdmin;
  late bool _userIsStaff;
  late bool _userIsDriver;

  var _enteredName = '';
  var _enteredPassword = '';
  //var _enteredPhone = '';
  var _enteredPhone = '';
  //var _enteredCompanyCode = '';

  void loginForm() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
    }

    switch (_userRole) {
      case UserRole.admin:
        {
          final admin = Admin(
            name: _enteredName,
            phone: _enteredPhone,
            password: _enteredPassword,
          );

          final auth = Auth();

          final statusCode = await auth.registerAdmin(admin);

          if (statusCode == 201) {
            navigateDynamic(model: admin, userRole: "admin");
          }
        }
        break;
      case UserRole.staff:
        {
          final staff = Staff(
              name: _enteredName,
              phone: _enteredPhone,
              password: _enteredPassword);
          navigateDynamic(model: staff, userRole: "staff");
        }
        break;
      case UserRole.driver:
        {
          final driver = Driver(
            name: _enteredName,
            phone: _enteredPhone,
            password: _enteredPassword,
          );

          final auth = Auth();
          final prefs = SharedPrefs();
          final statusCode = await auth.registerDriver(driver);
          final usersList = await prefs.getAuthedFromPrefs();

          if (statusCode == 201) {
            navigateDynamic(
                model: driver, userRole: "driver", users: usersList);
          }
        }
        break;
    }
  }

  void navigateDynamic({
    dynamic model,
    String? userRole,
    List<AuthedUser>? users,
  }) {
    switch (userRole) {
      case "admin":
        {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AdminMainPage(
                admin: model as Admin,
              ),
            ),
          );
        }
        break;
      case "staff":
        {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WarehouseMainPage(
                staff: model as Staff,
              ),
            ),
          );
        }
        break;
      case "driver":
        {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DriverMainPage(
                driver: model as Driver,
                usersList: users,
              ),
            ),
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _userIsAdmin = _userRole == UserRole.admin;
    _userIsStaff = _userRole == UserRole.staff;
    _userIsDriver = _userRole == UserRole.driver;

    return Scaffold(
      backgroundColor: GlobalConstants.mainBlue,
      body: Container(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: viewportConstraints.maxHeight),
                child: Container(
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: GlobalConstants.mainBlue,
                          height: MediaQuery.of(context).size.height * 0.28,
                          child: Center(
                            child: Text(
                              'Welcome To Logix, Driver',
                              style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                  fontSize: 26,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(30),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Form(
                                key: _formkey,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: nameController,
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value.trim().length <= 1 ||
                                            value.trim().length >= 50) {
                                          return 'Must be between 1 and 50 characters';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _enteredName = value!;
                                      },
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: 'Your Name Here',
                                        suffixIcon: const Icon(Icons.person),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide:
                                              const BorderSide(width: 4),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: phoneController,
                                      keyboardType: TextInputType.phone,
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value.trim().length <= 1 ||
                                            value.trim().length >= 50) {
                                          return 'Must be between 1 and 50 characters';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        if (_userIsAdmin) {
                                          _enteredPhone = value!;
                                        } //else {
                                        //_enteredPhone = value!;
                                        // }
                                      },
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: _userIsAdmin
                                            ? 'Your phone Here'
                                            : 'Your Phone Number Here',
                                        suffixIcon: const Icon(Icons.phone),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide:
                                              const BorderSide(width: 4),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: passwordController,
                                      obscureText: true,
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value.trim().length <= 1 ||
                                            value.trim().length >= 50) {
                                          return 'Must be between 1 and 50 characters';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _enteredPassword = value!;
                                      },
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: 'Your Password Here',
                                        suffixIcon: const Icon(Icons.key),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide:
                                              const BorderSide(width: 4),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value.trim().length <= 1 ||
                                            value.trim().length >= 50) {
                                          return 'Must be between 1 and 50 characters';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        /*
                                        if (_userIsAdmin) {
                                          _enteredPhone = value!;
                                        } else {
                                          _enteredCompanyCode = value!;
                                        }
                                        */
                                      },
                                      controller: _userIsAdmin
                                          ? phoneController
                                          : companyCodeController,
                                      keyboardType: _userIsAdmin
                                          ? TextInputType.phone
                                          : TextInputType.text,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: _userIsAdmin
                                            ? 'Your Phone Number Here'
                                            : 'Your Company Code Here',
                                        suffixIcon: const Icon(Icons.mail),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide:
                                              const BorderSide(width: 4),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 300,
                                      height: 120,
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 20),
                                          Text(
                                            'choose your role:',
                                            style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _userRole = UserRole.admin;
                                                    nameController.clear();
                                                    phoneController.clear();
                                                    phoneController.clear();
                                                  });
                                                },
                                                child: Container(
                                                  width: 85,
                                                  height: 35,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: _userIsAdmin
                                                        ? GlobalConstants
                                                            .mainBlue
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    border: _userIsAdmin
                                                        ? Border.all(width: 0)
                                                        : Border.all(
                                                            width: 2,
                                                            color:
                                                                GlobalConstants
                                                                    .mainBlue,
                                                          ),
                                                  ),
                                                  child: Text(
                                                    'Admin',
                                                    style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _userIsAdmin
                                                            ? Colors.white
                                                            : GlobalConstants
                                                                .mainBlue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _userRole = UserRole.staff;
                                                    nameController.clear();
                                                    phoneController.clear();
                                                    companyCodeController
                                                        .clear();
                                                  });
                                                },
                                                child: Container(
                                                  width: 85,
                                                  height: 35,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: _userIsStaff
                                                        ? GlobalConstants
                                                            .mainBlue
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    border: _userIsStaff
                                                        ? Border.all(width: 0)
                                                        : Border.all(
                                                            width: 2,
                                                            color:
                                                                GlobalConstants
                                                                    .mainBlue,
                                                          ),
                                                  ),
                                                  child: Text(
                                                    'Staff',
                                                    style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _userIsStaff
                                                            ? Colors.white
                                                            : GlobalConstants
                                                                .mainBlue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _userRole = UserRole.driver;
                                                    nameController.clear();
                                                    phoneController.clear();
                                                    companyCodeController
                                                        .clear();
                                                  });
                                                },
                                                child: Container(
                                                  width: 85,
                                                  height: 35,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: _userIsDriver
                                                        ? GlobalConstants
                                                            .mainBlue
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    border: _userIsDriver
                                                        ? Border.all(width: 0)
                                                        : Border.all(
                                                            width: 2,
                                                            color:
                                                                GlobalConstants
                                                                    .mainBlue),
                                                  ),
                                                  child: Text(
                                                    'Driver',
                                                    style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _userIsDriver
                                                            ? Colors.white
                                                            : GlobalConstants
                                                                .mainBlue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        loginForm();
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 40,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: GlobalConstants.mainBlue,
                                        ),
                                        child: Text(
                                          'Register',
                                          style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 22,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          'Already have an account? ',
                                          style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                              fontSize: 16,
                                              color: GlobalConstants.mainBlue,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            widget.changePage();
                                          },
                                          child: Text(
                                            'Sign In.',
                                            style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                fontSize: 16,
                                                color: GlobalConstants.mainBlue,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
