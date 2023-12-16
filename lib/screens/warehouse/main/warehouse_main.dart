import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logixx/models/company.dart';
import 'package:logixx/screens/commons.dart';

import '../../../models/staff.dart';
import '../../../models/auth_user.dart';
import '../../../utils/constants.dart';

// ignore: must_be_immutable
class WarehouseMainPage extends StatefulWidget {
  WarehouseMainPage({
    super.key,
    required this.staff,
    this.company,
    this.usersList,
  });
  List<AuthedUser>? usersList;
  final Company? company;
  final Staff staff;

  @override
  _WarehouseMainPageState createState() => _WarehouseMainPageState();
}

class _WarehouseMainPageState extends State<WarehouseMainPage> {
  bool _moreAccountsTabSelected = true;
  final commons = CommonMethos();
  @override
  Widget build(BuildContext context) {
    final staff = widget.staff;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Logix Staff Page',
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
                      staff.name,
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
                          staff.email,
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
                  'New Stock',
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
