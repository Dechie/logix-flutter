import 'package:flutter/material.dart';

import '../../../../models/admin.dart';
import '../../../../models/company.dart';
import '../../../../models/route.dart';
import '../../../../models/warehouse.dart';
import '../../../../services/api/tenant/tenant_api.dart';

class AdminWarehouseScreen extends StatefulWidget {
  const AdminWarehouseScreen({
    super.key,
    required this.admin,
    required this.company,
  });
  final Company company;
  final Admin admin;
  @override
  State<AdminWarehouseScreen> createState() => _AdminWarehouseScreenState();
}

class _AdminWarehouseScreenState extends State<AdminWarehouseScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String location = '';

  void sendFormData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }

  List<Warehouse> warehouses = [];
  final tenantApi = TenantApi();

  final _nameController = TextEditingController();

  void onCreateWarehouse() async {
    late int statusCode;
    name = _nameController.text;

    var newWarehouse = Warehouse(name: name, location: location);

    statusCode = await tenantApi.createWarehouse(
        newWarehouse, widget.admin, widget.company);
    if (statusCode == 200) {
      fetchWarehouses(widget.company.companyId!);
    }
  }

  void refresh() async {
    fetchWarehouses(widget.company.companyId!);
  }

  void fetchWarehouses(int tenantId) async {
    int statusCode = 0;
    List<Warehouse> fetched = [];
    fetched = await tenantApi.fetchWarehouses(widget.company, widget.admin);
    if (fetched.isNotEmpty) {
      setState(() {
        warehouses = fetched;
      });
    }
  }

  void createWarehouse() async {
    //final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    showModalBottomSheet(
        context: context,
        builder: (context) {
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
                    onCreateWarehouse();
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
    fetchWarehouses(widget.company.companyId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: warehouses.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                height: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Warehouses',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: warehouses.length,
                        itemBuilder: (ctx, index) => Card(
                          elevation: 5,
                          shadowColor: const Color.fromARGB(255, 33, 47, 243),
                          child: ListTile(
                            title: Text(
                              warehouses[index].name,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                const Icon(Icons.location_city),
                                Text(
                                  warehouses[index].location,
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
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
              child: Text('No Warehouses so far'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createWarehouse();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
