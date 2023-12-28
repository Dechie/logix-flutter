import 'package:flutter/material.dart';

import '../../../../models/company.dart';
import '../../../../models/order.dart';
import '../../../../models/staff.dart';
import '../../../../models/stock.dart';
import '../../../../services/api/tenant/tenant_api.dart';
import '../../../../services/sqlite/db_helper.dart';

class CreateStock extends StatefulWidget {
  CreateStock({
    super.key,
    required this.staff,
    required this.company,
  });

  final Staff staff;
  final Company company;

  @override
  _CreateStockState createState() => _CreateStockState();
}

class _CreateStockState extends State<CreateStock> {
  List<Order> orders = [];
  List<Stock> stocks = [];
  List<Stock> orderStocks = [];

  String orderName = '';
  final orderNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<int> onCreateOrder() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var order = Order(
        name: orderName,
        staffEmail: widget.staff.email,
      );

      //var dbHelper = DatabaseHelper();
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      await dbHelper.database;
      dbHelper.insertOrder(order);

      orders.add(order);
    }

    fetchOrders();
    return 300;
  }

  void sendOrderToBackend(Order order) async {}

  Future<void> fetchStocks() async {
    final tenant = TenantApi();
    List<Stock> fetched =
        await tenant.fetchStocks(widget.company, widget.staff);
    print('fetched: $fetched');

    setState(() {
      stocks = fetched;
    });
  }

  void onAddStock() {}

  void fetchOrders() async {
    //var dbHelper = DatabaseHelper();
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    await dbHelper.database; // waits until db is initialized
    List<Order> fetched = await dbHelper.retrieveOrders();
    if (fetched.isNotEmpty) {
      setState(() {
        orders = fetched;
      });
    }
  }

  void addStocksToOrder(Order order, List<Stock> stocks) async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    await dbHelper.database; // waits until db is initialized
    dbHelper.insertStocks(order, stocks);

    List<Stock> test = await dbHelper.retrieveStocks(order);
    print(test);
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
    fetchStocks();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => SizedBox(
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
                            controller: orderNameController,
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
                              orderName = value!;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            onCreateOrder();
                            Navigator.pop(context);
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .7,
              height: MediaQuery.of(context).size.height * .58,
              child: ListView.separated(
                itemCount: orders.length,
                itemBuilder: (context, index) => SizedBox(
                  height: 80,
                  width: 380,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(width: 3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(orders[index].name),
                            const SizedBox(width: 10),
                            Text('${orders[index].stocks?.length ?? 0} Stocks'),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 5),
                            TextButton.icon(
                              onPressed: () async {
                                fetchStocks();

                                print('items to send: $stocks');
                                List<String> _selectedItems = [];
                                final List<String>? results = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return MultiSelect(items: stocks);
                                  },
                                );

                                // Update UI
                                if (results != null) {
                                  setState(() {
                                    _selectedItems = results;
                                  });
                                }

                                for (var item in _selectedItems) {
                                  var id = double.parse(item
                                      .split(':')
                                      .last
                                      .split(',')
                                      .first
                                      .trimLeft());

                                  var found = stocks.firstWhere(
                                      (element) => element.price == id);
                                  orderStocks.add(found);
                                  addStocksToOrder(
                                    orders[index],
                                    orderStocks,
                                  );
                                }
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add Stock'),
                            ),
                            const SizedBox(width: 5),
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.add),
                              label: const Text('Send Order'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MultiSelect extends StatefulWidget {
  final List<Stock> items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  final List<String> _selectedItems = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    List<String> itemsString = widget.items
        .map(
          (e) => '${e.orderId}:${e.price},${e.arrivedDate}',
        )
        .toList();
    print('items stock: ${widget.items}');
    print(itemsString);
    return AlertDialog(
      title: const Text('Select Topics'),
      content: SingleChildScrollView(
        child: ListBody(
          children: itemsString
              .map((item) => CheckboxListTile(
                    value: _selectedItems.contains(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
