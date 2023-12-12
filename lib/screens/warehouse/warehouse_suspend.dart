import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logixx/screens/commons.dart';

import '../../models/company.dart';
import '../../models/staff.dart';
import '../../models/auth_user.dart';
import '../../services/central_api.dart';
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
  var companies = [];
  void fetchCompanies() async {
    final api = Api();
    List<Company> fetched = await api.fetchAllCompanies();

    setState(() {
      companies = fetched;
    });
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
                    onTap: () {
                      // apply to company function
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
    fetchCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Choose Company',
          style: GoogleFonts.montserrat(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
          itemCount: companies.length,
          itemBuilder: (ctx, index) => GestureDetector(
            onTap: () {
              onApplyCompany(companies[index]);
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
          separatorBuilder: (ctx, index) => const SizedBox(height: 10),
        ),
      ),
    );
  }
}
