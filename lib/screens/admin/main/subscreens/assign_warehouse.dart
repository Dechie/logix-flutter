import 'package:flutter/material.dart';
import 'package:logixx/services/api/tenant/tenant_api.dart';

import '../../../../models/admin.dart';
import '../../../../models/company.dart';
import '../../../../models/staff.dart';
import '../../../../models/warehouse.dart';

class AssignWarehouseWidget extends StatefulWidget {
  AssignWarehouseWidget({
    super.key,
    required this.staff,
    required this.company,
    required this.admin,
  });

  final Staff staff;
  final Company company;
  final Admin admin;

  @override
  State<AssignWarehouseWidget> createState() => _AssignWarehouseWidgetState();
}

class _AssignWarehouseWidgetState extends State<AssignWarehouseWidget> {
  List<Warehouse> warehouses = [];
  final tenantApi = TenantApi();

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

  void onAssignWarehouse(Warehouse warehouse, Staff staff) async {
    
  }
  @override
  void initState() {
    super.initState();
    fetchWarehouses(widget.company.companyId!);
  }

  @override
  Widget build(BuildContext context) {
    Staff staff = widget.staff;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .8,
          height: MediaQuery.of(context).size.height * .76,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Staff: ${widget.staff.name}'),
              const SizedBox(height: 30),
              Expanded(
                child: ListView.separated(
                  itemCount: warehouses.length,
                  itemBuilder: (ctx, index) => Card(
                    elevation: 5,
                    shadowColor: const Color.fromARGB(255, 33, 47, 243),
                    child: ListTile(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Apply Staff To Warehouse?'),
                            content: Column(
                              children: [
                                Text('Staff: ${staff.name}'),
                                Text('Warehouse: ${warehouses[index].name}'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  onAssignWarehouse(warehouses[index], staff);
                                },
                                child: const Text('Assign'),
                              ),
                            ],
                          ),
                        );
                      },
                      title: Text(
                        warehouses[index].name,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
