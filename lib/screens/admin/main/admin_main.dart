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
import '../dashboard_two.dart';

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

  var companies = <Company>[];
  var scaffoldKey;
  void fetchCompanies() async {
    String? token = widget.admin.token ?? '';
    final api = Api();
    List<Company> fetched = [];
    int stCode = -1;
    (fetched, stCode) = await api.fetchCompanies(token);
    print(stCode);

    if (fetched.isNotEmpty) {
      print(fetched);
    }
    setState(() {
      companies = fetched;
    });
  }

  @override
  void initState() {
    super.initState();
    scaffoldKey = GlobalKey<ScaffoldState>();
    admin = widget.admin;
    fetchCompanies();
    companiesPage = CompanyDashboard(
      admin: admin,
      companies: companies,
    );
    statsPage = GetStats();
    activeScreen = companiesPage;
  }

  bool _moreAccountsTabSelected = false;

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

    print('admin token to create company: ${widget.admin.token}');
    await central.createCompany(company, widget.admin);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void createNewCompany() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .6,
            child: Padding(
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
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    for (var comp in companies) {
      print(comp.name);
    }
    final admin = widget.admin;
    //Widget activeScreen = companiesPage;
    // print(activeScreen);
    return Scaffold(
      //backgroundColor: Colors.white,
      //backgroundColor: ThemeData.light().primaryColor,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          'Companies',
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              //color: GlobalConstants.mainBlue,
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
            // child: Padding(
            //   padding: const EdgeInsets.all(5.0),
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: SizedBox(
            //       height: 50,
            //       child: DecoratedBox(
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.circular(20),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // child: Text('You have x companies'),
          ),
        ),
        // bottom: PreferredSize(
        //   preferredSize: const Size(
        //     double.infinity,
        //     80,
        //   ),
        //   child: SizedBox(
        //     child: DecoratedBox(
        //       decoration: const BoxDecoration(
        //         borderRadius: BorderRadius.only(
        //           bottomLeft: Radius.circular(25),
        //           bottomRight: Radius.circular(25),
        //         ),
        //       ),
        //       child: Padding(
        //         padding: const EdgeInsets.all(5.0),
        //         child: Align(
        //           alignment: Alignment.bottomCenter,
        //           child: SizedBox(
        //             height: 50,
        //             child: DecoratedBox(
        //               decoration: BoxDecoration(
        //                 color: Colors.white,
        //                 borderRadius: BorderRadius.circular(20),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        actions: [
          IconButton(
            onPressed: fetchCompanies,
            icon: const Icon(
              Icons.refresh,
              color: Colors.black,
            ),
          ),
        ],
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
        backgroundColor: Colors.white,
        width: MediaQuery.of(context).size.width * .72,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      GlobalConstants.mainBlue,
                      //GlobalConstants.mainBlue.withOpacity(.85),
                      GlobalConstants.mainBlue.withOpacity(.67),
                    ],
                    center: Alignment.bottomLeft,
                    radius: 2,
                  ),
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
                          //color: GlobalConstants.mainBlue,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          admin.phone,
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              //color: GlobalConstants.mainBlue,
                              color: Colors.white,
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
                          icon: Icon(
                            _moreAccountsTabSelected
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                          ),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (_moreAccountsTabSelected)
                commons.showMoreAccounts(context, widget.usersList!),
              // ListTile(
              //   title: Text(
              //     'MyCompany',
              //     style: GoogleFonts.roboto(
              //       textStyle: const TextStyle(
              //         fontWeight: FontWeight.w600,
              //         fontSize: 18,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              //   onTap: () {
              //     Navigator.pop(context);
              //     setState(() {
              //       activeScreen = companiesPage;
              //     });
              //   },
              // ),
              // ListTile(
              //   title: Text(
              //     'Employees',
              //     style: GoogleFonts.roboto(
              //       textStyle: const TextStyle(
              //         fontWeight: FontWeight.w600,
              //         fontSize: 18,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              //   onTap: () {
              //     Navigator.pop(context);
              //     setState(() {});
              //   },
              // ),
              // ListTile(
              //   title: Text(
              //     'New Route',
              //     style: GoogleFonts.roboto(
              //       textStyle: const TextStyle(
              //         fontWeight: FontWeight.w600,
              //         fontSize: 18,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              //   onTap: () {},
              // ),
              // ListTile(
              //   title: Text(
              //     'Statistics',
              //     style: GoogleFonts.roboto(
              //       textStyle: const TextStyle(
              //         fontWeight: FontWeight.w600,
              //         fontSize: 18,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              //   onTap: () {
              //     Navigator.pop(context);
              //     setState(() {
              //       activeScreen = statsPage;
              //       print(activeScreen);
              //     });
              //   },
              // ),
            ],
          ),
        ),
      ),
      // body: companiesPage,
      body: companies.isNotEmpty
          ? SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ListView.separated(
                      itemCount: companies.length,
                      itemBuilder: (ctx, index) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DashBoard(
                                company: companies[index],
                                admin: widget.admin,
                                title: companies[index].name,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 5,
                          shadowColor: GlobalConstants.mainBlue,
                          child: ListTile(
                            title: Text(
                              companies[index].name,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              'id: ${companies[index].companyId}',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      separatorBuilder: (ctx, index) =>
                          const SizedBox(height: 10),
                    ),
                  ),
                ),
              ),
            )
          : const Center(
              child: Text('No companies so far'),
            ),
    );
  }
}
