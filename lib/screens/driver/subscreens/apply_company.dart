import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../models/company.dart';
import '../../../models/driver.dart';
import '../../../services/api/central/central_api.dart';
import '../../../services/api/tenant/tenant_api.dart';
import '../../../services/shared_prefs.dart';
import '../../../utils/constants.dart';

class ApplyCompany extends StatefulWidget {
  ApplyCompany({
    super.key,
    required this.driver,
  });

  final Driver driver;

  @override
  _ApplyCompanyState createState() => _ApplyCompanyState();
}

class _ApplyCompanyState extends State<ApplyCompany> {
  List<Company> companies = [];

  bool isAppliedToCompany = false;
  bool isAssignedWarehouse = false;
  Company? appliedCompany;

  final companyIdController = TextEditingController();
  int companyId = 0;
  final _formKey = GlobalKey<FormState>();

  void onApplyToCompany(Driver driver) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }

    final api = Api();
    Company searchCompany = await api.findCompany(companyId);

    onApplyCompany(searchCompany);
  }

  void onApplyCompany(Company company) {
    showModalBottomSheet(
      isScrollControlled: true,
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
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onTap: () async {
                    // apply to company function
                    final tenant = TenantApi();

                    int statusCode = await tenant.applyEmployeeToCompany(
                      company: company,
                      theDriver: widget.driver,
                      employeeRole: 'driver',
                    );
                    print('status code: $statusCode');

                    var shPrefs = SharedPrefs();
                    //await shPrefs.saveStaffAppliedStatus(staff, company);
                    await shPrefs.saveDriverAppliedStatus(
                        widget.driver, company);

                    isAppliedToCompany = statusCode == 200;
                    if (isAppliedToCompany) {
                      appliedCompany = company;
                      setState(() {});

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
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
                child: DecoratedBox(
                  decoration:
                      const BoxDecoration(color: GlobalConstants.mainBlue),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Apply',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
