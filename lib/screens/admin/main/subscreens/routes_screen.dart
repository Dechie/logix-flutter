import 'package:flutter/material.dart';

import '../../../../models/admin.dart';
import '../../../../models/company.dart';
import '../../../../models/route.dart';
import '../../../../services/api/tenant/tenant_api.dart';
import '../../../../utils/constants.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({
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
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<TravelRoute> routes = [];
  final tenantApi = TenantApi();

  final _nameController = TextEditingController();
  String name = '';

  void onCreateRoute() async {
    late int statusCode;
    name = _nameController.text;

    statusCode =
        await tenantApi.createTravelRoute(name, widget.admin, widget.company);
    if (statusCode == 200) {
      fetchRoutes(widget.company.companyId!);
    }
  }

  void refresh() async {
    fetchRoutes(widget.company.companyId!);
  }

  void fetchRoutes(int tenantId) async {
    int statusCode = 0;
    List<TravelRoute> fetched = [];
    (statusCode, fetched) =
        await tenantApi.fetchTravelRoutes(tenantId, widget.admin);
    if (fetched.isNotEmpty) {
      setState(() {
        routes = fetched;
      });
    }
  }

  void createRoute() async {
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
            onPressed: refresh,
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
      body: routes.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ListView.separated(
                  itemCount: routes.length,
                  itemBuilder: (ctx, index) => Card(
                    elevation: 5,
                    shadowColor: const Color.fromARGB(255, 33, 47, 243),
                    child: ListTile(
                      title: Text(
                        //routes[index],
                        routes[index].name,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        'company id: ${routes[index].companyId}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
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
