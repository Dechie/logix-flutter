import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logixx/utils/constants.dart';

import '../../../../models/admin.dart';
import '../../../../models/company.dart';
import '../../../../services/api/tenant/tenant_api.dart';

class CompanyGeneral extends StatefulWidget {
  const CompanyGeneral({
    super.key,
    required this.company,
    required this.admin,
    required this.title,
    required this.scaffoldKey,
  });

  final Admin admin;
  final Company company;
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<CompanyGeneral> createState() => _CompanyGeneralState();
}

class _CompanyGeneralState extends State<CompanyGeneral> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var projects = [];
  final tenantApi = TenantApi();

  final _nameController = TextEditingController();
  String name = '';

  void onCreateProject() async {
    late int statusCode;
    name = _nameController.text;
    final admin = widget.admin;
    final company = widget.company;

    statusCode = await tenantApi.createProject(name, admin, company);
    if (statusCode == 200) {
      fetchProjects(2);
    }
  }

  void refresh() async {
    fetchProjects(2);
  }

  void fetchProjects(int selectTenant) async {
    List<String> fetched = [];
    late int statusCode;
    (statusCode, fetched) =
        await tenantApi.fetchProjects(selectTenant, widget.admin);
    if (statusCode == 200) {
      setState(() {
        projects = fetched;
      });
    } else if (statusCode == 302) {
      Navigator.pop(context);
    }
  }

  void createProject() async {
    //final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          /*
          return LayoutBuilder(builder: (context, constraints) {
            return SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    keyboardSpace + 16,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('name'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Create'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
          */
          return Column(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameController,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('name'),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  onCreateProject();
                  Navigator.pop(context);
                },
                child: const Text('Create'),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    fetchProjects(widget.company.companyId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () => widget.scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: onRefresh,
        //     icon: const Icon(
        //       Icons.refresh,
        //       color: GlobalConstants.mainBlue,
        //     ),
        //   ),
        // ],
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
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                height: 40,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: GlobalConstants.mainBlue,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Company 1',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const DetailView(
              title: "Number of Warehouses",
              sub: "Across several cities",
              numValue: 10,
            ),
            const DetailView(
              title: "Number of Drivers",
              sub: "Moving Stock around",
              numValue: 7,
            ),
            const DetailView(
              title: "Warehouse Staff",
              sub: "managing staff",
              numValue: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class DetailView extends StatelessWidget {
  const DetailView({
    super.key,
    required this.numValue,
    required this.title,
    required this.sub,
  });

  final int numValue;
  final String title;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .8,
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: GlobalConstants.mainBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  numValue.toString(),
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  sub,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
