import 'package:flutter/material.dart';

import '../../../models/admin.dart';
import '../../../models/company.dart';
import '../../../models/route.dart';
import '../../../services/tenant_api.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({
    super.key,
    required this.admin,
    required this.company,
  });
  final Company company;
  final Admin admin;
  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  List<TravelRoute> projects = [];
  final tenantApi = TenantApi();

  final _nameController = TextEditingController();
  String name = '';

  void onCreateRoute() async {
    late int statusCode;
    name = _nameController.text;

    statusCode = await tenantApi.createTravelRoute(name);
    if (statusCode == 200) {
      fetchRoutes(widget.company.companyId!);
    }
  }

  void refresh() async {
    fetchRoutes(widget.company.companyId!);
  }

  void fetchRoutes(int tenantId) async {
    List<TravelRoute> fetched = [];
    fetched = await tenantApi.fetchTravelRoutes(tenantId);
    if (fetched.isNotEmpty) {
      setState(() {
        projects = fetched;
      });
    }
  }

  void createRoute() async {
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
          return Padding(
            padding: const EdgeInsets.all(16),
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
                  onPressed: () {
                    onCreateRoute();
                    Navigator.pop(context);
                  },
                  child: const Text('Create'),
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchRoutes(widget.company.companyId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: projects.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                height: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Routes',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: projects.length,
                        itemBuilder: (ctx, index) => Card(
                          elevation: 5,
                          shadowColor: const Color.fromARGB(255, 33, 47, 243),
                          child: ListTile(
                            title: Text(
                              //projects[index],
                              projects[index].name,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              'company id: ${projects[index].companyId}',
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: Text('No routes so far'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createRoute();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
