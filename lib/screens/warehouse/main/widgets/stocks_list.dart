import 'package:flutter/material.dart';
import 'package:logixx/screens/warehouse/main/widgets/new_stock.dart';

import '../../../../models/company.dart';
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
  }

  Map<String, Color> statusMap = {
    'to be shipped': Colors.green,
    'just arrived': Colors.yellow,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: statusMap[stocks[index].status],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        stocks[index].status,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Batch: ${stocks[index].quantity}',
                        style: const TextStyle(
                          fontSize: 16,
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
                      const Spacer(),
                      const Icon(Icons.calendar_view_day),
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
          separatorBuilder: (ctx, index) => const SizedBox(height: 30),
        ),
      ),
    );
  }
}
