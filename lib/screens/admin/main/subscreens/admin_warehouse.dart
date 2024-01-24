import 'package:flutter/material.dart';

import '../../../../models/admin.dart';
import '../../../../models/company.dart';
import '../../../../models/route.dart';
import '../../../../models/warehouse.dart';
import '../../../../services/api/tenant/tenant_api.dart';
import '../../../../utils/constants.dart';

class AdminWarehouseScreen extends StatefulWidget {
  const AdminWarehouseScreen({
    super.key,
    required this.admin,
    required this.company,
    required this.title,
    required this.scaffoldKey,
  });
  final Company company;
  final Admin admin;
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<AdminWarehouseScreen> createState() => _AdminWarehouseScreenState();
}

class _AdminWarehouseScreenState extends State<AdminWarehouseScreen> {
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String name = '';
  String location = '';
  List<String> locationCities = ['Addis Ababa', 'Dire Dawa', 'Adama'];

  void sendFormData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }

  List<Warehouse> warehouses = [];
  final tenantApi = TenantApi();

  final _nameController = TextEditingController();
  final _locationController = TextEditingController();

  Future<int> onCreateWarehouse() async {
    late int statusCode;
    name = _nameController.text;

    var newWarehouse = Warehouse(name: name, location: location);

    statusCode = await tenantApi.createWarehouse(
        newWarehouse, widget.admin, widget.company);
    if (statusCode == 200) {
      fetchWarehouses(widget.company.companyId!);
    }
    return statusCode;
  }

  void refresh() async {
    fetchWarehouses(widget.company.companyId!);
  }

  void fetchWarehouses(int tenantId) async {
    int statusCode = 0;
    print('fetch Warehouses executed');
    List<Warehouse> fetched = [];
    fetched = await tenantApi.fetchWarehouses(widget.company, widget.admin);
    if (fetched.isNotEmpty) {
      setState(() {
        warehouses = fetched;
        print(warehouses);
      });
    }
  }

  void createWarehouse() async {
    //final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .65,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              label: const Text('Quantity'),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().length <= 1 ||
                                  value.trim().length >= 50) {
                                return 'Please enter a value';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              name = value!;
                            },
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 165,
                            child: DropdownMenu<String>(
                              width: 160,
                              initialSelection: '',
                              controller: _locationController,
                              requestFocusOnTap: true,
                              label: const Text('Choose location'),
                              onSelected: (value) {
                                setState(() {
                                  location = value!;
                                });
                              },
                              dropdownMenuEntries: locationCities
                                  .map<DropdownMenuEntry<String>>(
                                    (type) => DropdownMenuEntry<String>(
                                      value: type,
                                      label: type,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () async {
                        int stCode = await onCreateWarehouse();

                        if (stCode == 200 || stCode == 201) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ));
        });
  }

  @override
  void initState() {
    super.initState();
    fetchWarehouses(widget.company.companyId!);
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
        actions: [
          IconButton(
            onPressed: () {
              fetchWarehouses(widget.company.companyId!);
            },
            icon: const Icon(
              Icons.refresh,
              color: Colors.black,
            ),
          ),
        ],
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
      body: warehouses.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Expanded(
                  child: ListView.separated(
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
                            const Icon(Icons.location_on),
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
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                  ),
                ),
              ),
            )
          : const Center(
              child: Text('No Warehouses so far'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createWarehouse();
          refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
