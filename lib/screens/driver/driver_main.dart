import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logixx/screens/commons.dart';

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
  bool _moreAccountsTabSelected = true;
  final commons = CommonMethos();
  @override
  Widget build(BuildContext context) {
    final driver = widget.driver;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Logix Driver Page',
          style: GoogleFonts.montserrat(),
        ),
      ),
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
                      style: GoogleFonts.montserrat(
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
                          driver.email,
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
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  'MyCompany',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  'MyCompany',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
