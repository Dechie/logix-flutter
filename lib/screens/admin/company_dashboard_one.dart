import 'package:flutter/material.dart';
import 'package:logixx/utils/constants.dart';

import '../../models/admin.dart';
import '../../models/company.dart';
import '../../services/api/central/central_api.dart';
import 'dashboard_two.dart';

class CompanyDashboard extends StatefulWidget {
  const CompanyDashboard({
    super.key,
    required this.admin,
  });
  final Admin admin;

  @override
  _CompanyDashboardState createState() => _CompanyDashboardState();
}

class _CompanyDashboardState extends State<CompanyDashboard> {
  var companies = [];
  void fetchCompanies() async {
    String? token = widget.admin.token;
    final api = Api();
    List<Company> fetched = await api.fetchCompanies(token!);

    if (fetched.isNotEmpty) {
      print(fetched);
    }
    setState(() {
      companies = fetched;
    });
  }

  String companyName = '';
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void sendFormData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    final company = Company(name: companyName);

    final central = Api();

    await central.createCompany(company, widget.admin);

    if (!context.mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  void createNewCompany() {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length <= 1 ||
                              value.trim().length >= 50) {
                            return 'Must be between 1 and 50 characters';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          companyName = value!;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: sendFormData,
                  child: const Text('Submit'),
                ),
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
    return Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 11,
                  child: Container(
                      alignment: Alignment.center, child: Text('Companies')),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: FloatingActionButton(
                      onPressed: fetchCompanies,
                      child: const Icon(Icons.refresh),
                    ),
                  ),
                ),
                //const Spacer(),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: FloatingActionButton(
                      onPressed: createNewCompany,
                      child: const Text('New'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            companies.isNotEmpty
                ? Expanded(
                    child: ListView.separated(
                      itemCount: companies.length,
                      itemBuilder: (ctx, index) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DashBoard(
                                company: companies[index],
                                admin: widget.admin,
                                title: companies[index].name,
                              ),
                            ),
                          );
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
                      separatorBuilder: (ctx, index) =>
                          const SizedBox(height: 10),
                    ),
                  )
                : const Center(
                    child: Text('No companies so far'),
                  ),
          ],
        ));
  }
}
