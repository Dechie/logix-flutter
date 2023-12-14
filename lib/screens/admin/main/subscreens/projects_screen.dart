import 'package:flutter/material.dart';

import '../../../../models/admin.dart';
import '../../../../models/company.dart';
import '../../../../services/tenant_api.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({
    super.key,
    required this.company,
    required this.admin,
  });

  final Admin admin;
  final Company company;

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
