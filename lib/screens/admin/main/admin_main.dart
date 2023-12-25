import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logixx/models/auth_user.dart';
import 'package:logixx/screens/admin/company_dashboard_one.dart';
import 'package:logixx/screens/admin/main/subscreens/employees.dart';
import 'package:logixx/screens/admin/widgets/get_stats.dart';
import 'package:logixx/screens/commons.dart';

import '../../../models/admin.dart';
import '../../../models/company.dart';
import '../../../services/api/central/central_api.dart';
import '../../../utils/constants.dart';

class AdminMainPage extends StatefulWidget {
  AdminMainPage({
    super.key,
    required this.admin,
    this.usersList,
  });

  final Admin admin;
  List<AuthedUser>? usersList;
  @override
  _AdminMainPageState createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  late Admin admin;
  late Widget companiesPage;
  late Widget statsPage;
  late Widget activeScreen;

  @override
  void initState() {
    super.initState();
    admin = widget.admin;
    companiesPage = CompanyDashboard(admin: admin);
    statsPage = GetStats();
    activeScreen = companiesPage;
  }

  bool _moreAccountsTabSelected = true;

  final commons = CommonMethos();

  String companyName = '';
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void sendFormData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    final company = Company(name: companyName);

    final central = Api();

    await central.createCompany(company, widget.admin);

    if (!context.mounted) {
      Navigator.of(context).pop();
    }
  }

  void createNewCompany() {
    showModalBottomSheet(
      isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                            hintText: 'Company Name', border: InputBorder.none),
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
                          companyName = value!;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextButton(
                        onPressed: sendFormData,
                        child: const Text('Submit'),
                      ),
                      const SizedBox(width: 30),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final admin = widget.admin;
    //Widget activeScreen = companiesPage;
    print(activeScreen);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Logix Admin Page',
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              color: GlobalConstants.mainBlue,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      floatingActionButton: activeScreen == companiesPage
          ? FloatingActionButton(
              onPressed: () {
                createNewCompany();
              },
              child: const Icon(
                Icons.add,
                size: 28,
              ),
            )
          : null,
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
                      admin.name,
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
                          admin.email,
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
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    activeScreen = companiesPage;
                  });
                },
              ),
              ListTile(
                title: Text(
                  'Employees',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {});
                },
              ),
              ListTile(
                title: Text(
                  'New Route',
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
                  'Statistics',
                  style: GoogleFonts.montserrat(
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
                    activeScreen = statsPage;
                    print(activeScreen);
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: activeScreen,
    );
  }
}
