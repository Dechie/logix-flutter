import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logixx/screens/warehouse/main/widgets/new_stock.dart';
import 'package:logixx/services/sqlite/db_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../models/company.dart';
import '../../../../models/order.dart';
import '../../../../models/staff.dart';
import '../../../../models/stock.dart';
import '../../../../services/api/tenant/tenant_api.dart';
import '../../../../utils/constants.dart';

// ignore: must_be_immutable
class StocksListPage extends StatefulWidget {
  const StocksListPage({
    super.key,
    required this.company,
    required this.staff,
  });

  final Company company;
  final Staff staff;

  @override
  State<StocksListPage> createState() => _StocksListPageState();
}

class _StocksListPageState extends State<StocksListPage> {
  List<Stock> stocks = [];
  List<Order> batches = [];

  String batchName = '';
  final batchameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<int> onCreateBatch() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var batch = Order(name: batchName, staffEmail: widget.staff.email);

      //var dbHelper = DatabaseHelper();
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      dbHelper.insertOrder(batch);

      batches.add(batch);
    }

    return 300;
  }

  void fetchBatches() async {
    //var dbHelper = DatabaseHelper();
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    await dbHelper.database; // waits until db is initialized
    List<Order> fetched = await dbHelper.retrieveOrders() as List<Order>;
    if (fetched.isNotEmpty) {
      setState(() {
        batches = fetched;
      });
    }
  }

  Future<void> fetchStocks() async {
    final tenant = TenantApi();
    List<Stock> fetched =
        await tenant.fetchStocks(widget.company, widget.staff);

    if (fetched.isNotEmpty) {
      setState(() {
        stocks = fetched;
      });
    }
  }

  void onCreateStock(Company company, Staff staff) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => NewStock(company: company, staff: staff),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchStocks();
    fetchBatches();
  }

  Map<String, Color> statusMap = {
    'to be shipped': Colors.green,
    'just arrived': Colors.yellow,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Material(
                  child: SizedBox(
                    width: 200,
                    height: 400,
                    child: ListView.separated(
                      itemCount: batches.length,
                      itemBuilder: (context, idx) => ListTile(
                        title: Text(batches[idx].name),
                        onTap: () {
                          // there are `index` number of stocks and `idx` number of batches
                          // the stocks for the one of the batch lists
                          // this is a list of lists soooo

                          Navigator.pop(context);
                        },
                      ),
                      separatorBuilder: (context, idx) => const Divider(),
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.list),
            label: const Text('List Batches'),
          ),
          TextButton.icon(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => createNewOrderWidget(context),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Prepare Batch'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () {
          onCreateStock(widget.company, widget.staff);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
          itemCount: stocks.length,
          itemBuilder: (ctx, index) => GestureDetector(
            onTap: () {},
            child: Card(
              //color: const Color.fromARGB(255, 190, 190, 190),
              elevation: 5,
              shadowColor: GlobalConstants.mainBlue,
              child: ListTile(
                  minLeadingWidth: 5,
                  leading: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: statusMap[stocks[index].status],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 0,
                        child: Text('Add To batch'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 0) {
                        showDialog(
                          context: context,
                          builder: (context) => Material(
                            child: SizedBox(
                              width: 200,
                              height: 400,
                              child: ListView.separated(
                                itemCount: batches.length,
                                itemBuilder: (context, idx) => ListTile(
                                  title: Text(batches[idx].name),
                                  onTap: () {
                                    // there are `index` number of stocks and `idx` number of batches
                                    // the stocks for the one of the batch lists
                                    // this is a list of lists soooo
                                    batches[idx].stocks = [];
                                    batches[idx].stocks!.add(stocks[index]);
                                    Navigator.pop(context);
                                  },
                                ),
                                separatorBuilder: (context, idx) =>
                                    const Divider(),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        stocks[index].status,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Batch: ${stocks[index].quantity}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      const Icon(Icons.money),
                      Text(
                        '${stocks[index].price}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Icon(Icons.date_range),
                      Text(
                        stocks[index].arrivedDate,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          separatorBuilder: (ctx, index) => const SizedBox(height: 20),
        ),
      ),
    );
  }

  SizedBox createNewOrderWidget(BuildContext context) {
    return SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * .67,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: batchameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            label: const Text('give name to batch'),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().length <= 1 ||
                                value.trim().length >= 50) {
                              return 'please enter valid name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            batchName = value!;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: onCreateBatch,
                        child: const Text('Submit'),
                      ),
                      /*
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * .45,
                        decoration: BoxDecoration(
                          border: Border.all(width: 3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                                color: GlobalConstants.mainBlue
                                    .withOpacity(0.35),
                              ),
                              child: Text(
                                'Choose A few stocks to start',
                                style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ]),
                      ),
                      */
                    ],
                  ),
                ),
              );
  }
}
