import 'package:flutter/material.dart';

import '../../../../models/admin.dart';
import '../../../../models/company.dart';
import '../../../../services/api/tenant/tenant_api.dart';
import '../../../../utils/constants.dart';

class ProjectScreen extends StatefulWidget {
  ProjectScreen({
    super.key,
    required this.company,
    required this.admin,
    required this.title,
    required this.scaffoldKey,
  });

  final Admin admin;
  final Company company;
  final String title;
  GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
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
      fetchProjects(company.companyId!);
    }
  }

  void refresh() async {
    fetchProjects(widget.company.companyId!);
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
        isScrollControlled: true,
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
      key: widget.scaffoldKey,
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
      //drawer: widget.drawer,
      body: projects.isNotEmpty
          ? ListView.builder(
              itemCount: projects.length,
              itemBuilder: (ctx, index) => Card(
                elevation: 5,
                shadowColor: const Color.fromARGB(255, 33, 47, 243),
                child: Text(
                  projects[index],
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            )
          : const Center(
              child: Text('No projects so far'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createProject();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
