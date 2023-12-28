import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logixx/screens/warehouse/main/warehouse_main.dart';
import 'package:logixx/services/shared_prefs.dart';

import '../../models/company.dart';
import '../../models/staff.dart';
import '../../models/auth_user.dart';
import '../../models/warehouse.dart';
import '../../services/api/central/central_api.dart';
import '../../services/api/tenant/tenant_api.dart';
import '../../utils/constants.dart';

// ignore: must_be_immutable
class WarehouseSuspendPage extends StatefulWidget {
  WarehouseSuspendPage({
    super.key,
    required this.staff,
    this.usersList,
  });
  List<AuthedUser>? usersList;
  final Staff staff;

  @override
  State<WarehouseSuspendPage> createState() => _WarehouseSuspendPageState();
}

class _WarehouseSuspendPageState extends State<WarehouseSuspendPage> {
  List<Company> companies = [];

  bool isAppliedToCompany = false;
  bool isAssignedWarehouse = false;
  Company? appliedCompany;
  Warehouse? assigedWarehouse;

  final companyIdController = TextEditingController();
  int companyId = 0;
  final _formKey = GlobalKey<FormState>();

  void sendFormData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }

  Future<bool> applyToCompany(Company company, Staff staff) async {
    print('this one executed');

    final tenant = TenantApi();

    int statusCode = await tenant.applyEmployeeToCompany(
      company: company,
      theStaff: staff,
      employeeRole: 'staff',
    );
    print('status code: $statusCode');

    var shPrefs = SharedPrefs();
    await shPrefs.saveStaffAppliedStatus(staff, company);

    return statusCode == 200;
  }

  Future<void> fetchCompanies() async {
    final api = Api();
    List<Company> fetched = await api.fetchAllCompanies();

    setState(() {
      companies = fetched;
      print(companies);
    });
  }

  Future<Company?> getCompany(int companyId) async {
    final api = Api();
    Company? found = await api.getOneCompany(companyId);

    return found;
  }

  void checkAppliedToCompany() async {
    var shPrefs = SharedPrefs();
    List<String> staffList = await shPrefs.getAppliedStaffs();
    print(staffList.isNotEmpty);

    String emailInQuestion = widget.staff.email;

    List<Map<String, String>> emails = staffList.map((stf) {
      List<String> splitted = stf.split(':');
      return {
        'email': splitted.first,
        'cId': splitted.last,
      };
    }).toList();

    List<String> emls = staffList.map((stf) => stf.split(':').first).toList();

    //isAppliedToCompany = emails.any((map) => map['email'] == emailInQuestion);
    isAppliedToCompany = emls.contains(emailInQuestion);

    if (isAppliedToCompany) {
      var matchVal =
          emails.firstWhere((entity) => entity['email'] == emailInQuestion);
      int? compId = int.parse(matchVal['cId']!);
      appliedCompany = await getCompany(compId);
      //companies.firstWhere((comp) => comp.companyId! == companyId);
      setState(() {});
    }
  }

  void checkAssignedWarehouse() async {
    var shPrefs = SharedPrefs();
    final wh = Warehouse(name: 'here', address: 'addis');
    List<String> staffList =
        await shPrefs.getWarehouseAssignedStaffs(widget.staff, wh);

    String emailInQuestion = widget.staff.email;

    List<Map<String, String>> emails = staffList.map((stf) {
      List<String> splitted = stf.split(':');
      return {
        'email': splitted.first,
        'wId': splitted.last,
      };
    }).toList();

    List<String> emls = staffList.map((stf) => stf.split(':').first).toList();

    //isAppliedToCompany = emails.any((map) => map['email'] == emailInQuestion);
    //isAssignedWarehouse = emls.contains(emailInQuestion);

    if (isAssignedWarehouse) {
      var matchVal =
          emails.firstWhere((entity) => entity['email'] == emailInQuestion);
      /*
      int? wareId = int.parse(matchVal['cId']!);
      assignedWarehouse = await getWarehouse(wareId);
      //companies.firstWhere((comp) => comp.companyId! == companyId);
      setState(() {});
      */
    }
  }

  void onApplyToCompany(Staff staff) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }

    final api = Api();
    Company searchCompany = await api.findCompany(companyId);

    onApplyCompany(searchCompany);
  }
/*
  Future<bool> onNotifyAdmin() async {
    var shPrefs = SharedPrefs();
    List<String> staffList = await shPrefs.getAppliedStaffs();

    String emailInQuestion = widget.staff.email;

    List<Map<String, String>> emails = staffList.map((stf) {
      List<String> splitted = stf.split(':');
      return {
        'email': splitted.first,
        'company_id': splitted.last,
      };
    }).toList();

    Map<String, String> ourMap =
        emails.firstWhere((stf) => stf['email'] == emailInQuestion);

    final staff = widget.staff;
    int companyId = int.parse(ourMap['company_id']!);
    final tenant = TenantApi();
    //bool isSent = await tenant.
    /*
    bool isSent = await tenant.sendEmployeeNotif(
        companyId: companyId, theStaff: staff, employeeRole: 'staff');
        */

    return true;
  }
  */

  void onCheckAppliedToWarehouse(Company company, Staff staff) async {
    final tenantApi = TenantApi();
    bool appliedToWarehouse =
        await tenantApi.checkWarehouseToCompany(company, staff);
    isAssignedWarehouse = appliedToWarehouse;
    setState(() {});
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
                          await applyToCompany(company, widget.staff);

                      if (isAppliedToCompany) {
                        appliedCompany = company;
                      }
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
                  builder: (context) => WarehouseMainPage(
                    staff: widget.staff,
                    company: appliedCompany!,
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
              child: isAssignedWarehouse
                  ? Center(
                      child: SizedBox(
                        width: 300,
                        height: 500,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                                'you have been successfully assigned a warehouse.'),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => WarehouseMainPage(
                                      staff: widget.staff,
                                      company: appliedCompany!,
                                      usersList: widget.usersList,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.arrow_forward_ios_rounded,
                              ),
                              label: const Text('Continue To Warehouse'),
                            ),
                          ],
                        ),
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
                              onPressed: () {
                                //onNotifyAdmin,
                                onCheckAppliedToWarehouse(
                                    appliedCompany!, widget.staff);
                              },
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
                      onApplyToCompany(widget.staff);
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .7,
                      height: 70,
                      child: const DecoratedBox(
                        decoration:
                            BoxDecoration(color: GlobalConstants.mainBlue),
                        child: Text('Apply'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
