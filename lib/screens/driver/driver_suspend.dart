import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logixx/services/shared_prefs.dart';

import '../../models/company.dart';
import '../../models/driver.dart';
import '../../models/auth_user.dart';
import '../../services/api/central/central_api.dart';
import '../../services/api/tenant/tenant_api.dart';
import '../../utils/constants.dart';
import 'driver_main.dart';

// ignore: must_be_immutable
class DriverSuspendPage extends StatefulWidget {
  DriverSuspendPage({
    super.key,
    required this.driver,
    this.usersList,
  });
  List<AuthedUser>? usersList;
  final Driver driver;

  @override
  State<DriverSuspendPage> createState() => _DriverSuspendPageState();
}

class _DriverSuspendPageState extends State<DriverSuspendPage> {
  List<Company> companies = [];

  bool isAppliedToCompany = false;
  bool isAssignedDriver = false;
  late Company appliedCompany;

  final companyIdController = TextEditingController();
  int companyId = 0;
  final _formKey = GlobalKey<FormState>();


  Future<bool> applyToCompany(Company company, Driver driver) async {
    print('this one executed');

    final tenant = TenantApi();

    int statusCode = await tenant.applyEmployeeToCompany(
      company: company,
      theDriver: driver,
      employeeRole: 'driver',
    );
    print('status code: $statusCode');

    var shPrefs = SharedPrefs();
    await shPrefs.saveDriverAppliedStatus(driver, company);

    return statusCode == 200;
  }

  void checkAppliedToCompany() async {
    var shPrefs = SharedPrefs();
    List<String> staffList = await shPrefs.getAppliedStaffs();

    String emailInQuestion = widget.driver.email;

    List<Map<String, String>> emails = staffList.map((stf) {
      List<String> splitted = stf.split(':');
      return {
        'email': splitted.first,
        'cId': splitted.last,
      };
    }).toList();

    List<String> emls = staffList.map((stf) => stf.split(':').first).toList();

    setState(() {
      //isAppliedToCompany = emails.any((map) => map['email'] == emailInQuestion);
      isAppliedToCompany = emls.contains(emailInQuestion);
    });
  }

  void onApplyToCompany(Driver driver) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }

    final api = Api();
    Company searchCompany = await api.findCompany(companyId);

    onApplyCompany(searchCompany);
  }

  Future<bool> onNotifyAdmin() async {
    var shPrefs = SharedPrefs();
    List<String> staffList = await shPrefs.getAppliedStaffs();

    String emailInQuestion = widget.driver.email;

    List<Map<String, String>> emails = staffList.map((stf) {
      List<String> splitted = stf.split(':');
      return {
        'email': splitted.first,
        'company_id': splitted.last,
      };
    }).toList();

    Map<String, String> ourMap =
        emails.firstWhere((stf) => stf['email'] == emailInQuestion);

    final driver = widget.driver;
    int companyId = int.parse(ourMap['company_id']!);
    final tenant = TenantApi();
    bool isSent = await tenant.sendEmployeeNotif(companyId: companyId, theDriver: driver, employeeRole: 'driver');

    return isSent;
  }

  void onApplyCompany(Company company) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 30),
                Text(company.name),
                const SizedBox(height: 10),
                Text('${company.companyId}'),
                const Spacer(),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * .7,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: const BoxDecoration(
                    color: GlobalConstants.mainBlue,
                  ),
                  child: GestureDetector(
                    child: SizedBox(
                      child: Text(
                        'Apply',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    onTap: () async {
                      // apply to company function
                      print('this one tapped');
                      isAppliedToCompany =
                          await applyToCompany(company, widget.driver);
                      setState(() {});

                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    checkAppliedToCompany();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Choose Company',
          style: GoogleFonts.montserrat(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DriverMainPage(
                    driver: widget.driver,
                    usersList: widget.usersList,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: isAppliedToCompany
          ? SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: isAssignedDriver
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                              'you have been successfully assigned a warehouse.'),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                            ),
                            label: const Text('Continue To Driver'),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'You Have not been assigned a warehouse yet. Notify admin to be assigned.',
                            ),
                            TextButton.icon(
                              onPressed: onNotifyAdmin,
                              icon: const Icon(
                                Icons.arrow_forward_ios_rounded,
                              ),
                              label: const Text('Notify Admin'),
                            ),
                          ],
                        ),
                      ),
                    ),
            )
          : Center(
              child: Column(
                children: [
                  const Text('Enter your company code to apply'),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .7,
                    height: 70,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: companyIdController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          label: const Text('company code'),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length <= 1 ||
                              value.trim().length >= 50 ||
                              int.tryParse(value) is! int) {
                            return 'Please enter a number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          companyId = int.parse(value!);
                        },
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      onApplyToCompany(widget.driver);
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .7,
                      height: 70,
                      child: const DecoratedBox(
                        decoration:
                            BoxDecoration(color: GlobalConstants.mainBlue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
