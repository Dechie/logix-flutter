import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/admin.dart';
import '../../models/company.dart';
import '../../models/route.dart';
import '../../utils/constants.dart';
import '../../services/tenant_api.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({
    super.key,
    required this.title,
    required this.company,
    required this.admin,
  });

  final String title;
  final Company company;
  final Admin admin;
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late Widget activeScreen;

  var projectScreen, routeScreen;
  List<String> projects = [];
  List<TravelRoute> routes = [];
  late int tenantId;

  @override
  void initState() {
    super.initState();
    tenantId = widget.company.companyId!;
    projectScreen = ProjectScreen(
      admin: widget.admin,
      company: widget.company,
    );
    routeScreen = RouteScreen(selectTenant: tenantId);
    activeScreen = projectScreen;
  }

  void onRefresh() {
    activeScreen == routeScreen
        ? routeScreen.refresh()
        : projectScreen.refresh();
  }

  void switchScreen(int newScreen) {
    switch (newScreen) {
      case 0:
        activeScreen = routeScreen;
        break;
      case 1:
        activeScreen = projectScreen;
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final admin = widget.admin;
    final company = widget.company;
    String title = widget.title;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: onRefresh,
            icon: const Icon(
              Icons.refresh,
              color: GlobalConstants.mainBlue,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: GlobalConstants.mainBlue,
        width: MediaQuery.of(context).size.width * .6,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              width: double.infinity,
              height: 150,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    admin.name,
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: GlobalConstants.mainBlue,
                      ),
                    ),
                  ),
                  Text(
                    '${company.name} id${company.companyId}',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: GlobalConstants.mainBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                'Routes',
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                switchScreen(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Projects',
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                switchScreen(1);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: activeScreen,
    );
  }
}

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
      fetchProjects(2);
    }
  }

  void refresh() async {
    fetchProjects(2);
  }

  void fetchProjects(int selectTenant) async {
    List<String> fetched = [];
    late int statusCode;
    (statusCode, fetched) = await tenantApi.fetchProjects(selectTenant);
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
    fetchProjects(2);
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

class RouteScreen extends StatefulWidget {
  const RouteScreen({
    super.key,
    required this.selectTenant,
  });
  final int selectTenant;
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
      fetchRoutes(2);
    }
  }

  void refresh() async {
    fetchRoutes(2);
  }

  void fetchRoutes(int selectTenant) async {
    List<TravelRoute> fetched = [];
    fetched = await tenantApi.fetchTravelRoutes(selectTenant);
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
    fetchRoutes(2);
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
