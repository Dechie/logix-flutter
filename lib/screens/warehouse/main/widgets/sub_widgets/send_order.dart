import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logixx/models/warehouse.dart';
import 'package:logixx/services/api/tenant/tenant_api.dart';

import '../../../../../models/company.dart';
import '../../../../../models/order.dart';
import '../../../../../models/staff.dart';

class SendOrderPage extends StatefulWidget {
  const SendOrderPage({
    super.key,
    required this.staff,
    required this.company,
    required this.order,
  });

  final Staff staff;
  final Company company;
  final Order order;

  @override
  State<SendOrderPage> createState() => _SendOrderPageState();
}

class _SendOrderPageState extends State<SendOrderPage> {
  late Staff staff;
  late Order order;
  late Company company;
  List<Warehouse> warehouses = [];

  void onSendOrder() {}

  void fetchWarehouses(int tenantId) async {
    final tenantApi = TenantApi();
    int statusCode = 0;
    print('fetch Warehouses executed');
    List<Warehouse> fetched = [];
    fetched = await tenantApi.fetchTheWarehouses(widget.company, widget.staff);
    if (fetched.isNotEmpty) {
      setState(() {
        warehouses = fetched;
        print(warehouses);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    staff = widget.staff;
    order = widget.order;
    order.stocks = [];
    final company = widget.company;
    fetchWarehouses(company.companyId!);
  }

  @override
  Widget build(BuildContext context) {
    List<Warehouse> warehouses = [];
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: SizedBox(
        width: size.width,
        height: size.height * .6,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text('Send an Order'),
              const SizedBox(height: 10),
              ListTile(
                title: Text('${order.id}: ${order.name}'),
                subtitle: Text('number of stocks: ${order.stocks!.length}'),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 30,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.grey),
                  child: Text(
                    'Choose Source Warehouse',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 30,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => SizedBox(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(warehouses[index].name),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 30,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.grey),
                  child: Text(
                    'Choose Destination Warehouse',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 30,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => SizedBox(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(warehouses[index].name),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onSendOrder,
                child: SizedBox(
                  width: double.infinity,
                  height: 30,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.grey),
                    child: Text(
                      'Choose Destination Warehouse',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
