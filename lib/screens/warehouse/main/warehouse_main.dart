import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logixx/models/company.dart';
import 'package:logixx/screens/commons.dart';
import 'package:logixx/screens/warehouse/main/widgets/create_order.dart';
import 'package:logixx/screens/warehouse/main/widgets/new_stock.dart';

import '../../../models/staff.dart';
import '../../../models/auth_user.dart';
import '../../../utils/constants.dart';
import 'widgets/stocks_list.dart';

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
  State<WarehouseMainPage> createState() => _WarehouseMainPageState();
}

class _WarehouseMainPageState extends State<WarehouseMainPage> {
  bool _moreAccountsTabSelected = true;
  final commons = CommonMethos();
  Widget active = const Center(
    child: Text('main widget'),
  );
  late Widget activeScreen;

  @override
  void initState() {
    super.initState();

    activeScreen = active;
  }

  @override
  Widget build(BuildContext context) {
    final staff = widget.staff;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Logix Staff Page',
          style: GoogleFonts.roboto(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ],
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
                          staff.phone,
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
                  'Stocks',
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    activeScreen = StocksListPage(
                      company: widget.company!,
                      staff: widget.staff,
                    );
                  });
                },
              ),
              ListTile(
                title: Text(
                  'Main Page',
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    activeScreen = active;
                  });
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
                  Navigator.pop(context);
                  setState(() {
                    activeScreen = CreateStock(
                      company: widget.company!,
                      staff: widget.staff,
                    );
                  });
                },
              ),
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
                onTap: () {},
              ),
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
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      body: activeScreen,
    );
  }
}
