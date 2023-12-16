import 'package:flutter/material.dart';
import 'package:logixx/services/tenant_api.dart';

import '../../../../models/company.dart';
import '../../../../models/staff.dart';
import '../../../../models/stock.dart';

class NewStock extends StatefulWidget {
  const NewStock({
    super.key,
    required this.company,
    required this.staff,
  });

  final Company company;
  final Staff staff;

  @override
  State<NewStock> createState() => _NewStockState();
}

class _NewStockState extends State<NewStock> {
  String companyName = '';
  int quantity = 0;
  double price = 0.0;
  String arrivedDate = '', status = '';

  var statusTypes = ['to be shipped', 'just arrived'];
  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final arrivedDateController = TextEditingController();
  final statusController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void sendFormData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }

    final stock = Stock(
      price: price,
      quantity: quantity,
      arrivedDate: arrivedDate,
      status: status,
    );

    final tenant = TenantApi();
    int statusCode =
        await tenant.createStock(stock, widget.company, widget.staff);
    if ((statusCode == 200 || statusCode == 201) && !context.mounted) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .65,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: quantityController,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1 ||
                            value.trim().length >= 50 ||
                            int.tryParse(value) is int) {
                          return 'Please enter a number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        quantity = int.parse(value!);
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: priceController,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1 ||
                            value.trim().length >= 50 ||
                            double.tryParse(value) is double) {
                          return 'Please enter a number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        price = double.parse(value!);
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: arrivedDateController,
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
                        arrivedDate = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownMenu<String>(
                      initialSelection: '',
                      controller: statusController,
                      requestFocusOnTap: true,
                      label: const Text('Color'),
                      onSelected: (value) {
                        setState(() {
                          status = value!;
                        });
                      },
                      dropdownMenuEntries: statusTypes
                          .map<DropdownMenuEntry<String>>(
                            (type) => DropdownMenuEntry<String>(
                              value: type,
                              label: type,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 20),
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
        ));
  }
}
