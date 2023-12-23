import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  Future<int> sendFormData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }

    final stock = Stock(
      // companyId: widget.company.companyId!,
      //warehouseId: 0,
      price: price,
      quantity: quantity,
      arrivedDate: arrivedDate,
      status: status,
    );

    final tenant = TenantApi();
    int statusCode =
        await tenant.createStock(stock, widget.company, widget.staff);
    return statusCode;
  }

  void onDatePicked() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: DateTime(2023),
      lastDate: DateTime(2024),
    );

    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate!);
    // TODO: add this as a global cause you will need it later on.
    setState(() {
      arrivedDate = formattedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      controller: quantityController,
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
                            value.trim().length >= 50 ||
                            int.tryParse(value) is! int) {
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
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        label: const Text('price'),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1 ||
                            value.trim().length >= 50 ||
                            double.tryParse(value) is! double) {
                          return 'Please enter a number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        price = double.parse(value!);
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            onDatePicked();
                          },
                          child: const Text('Arrived Date'),
                        ),
                        /*
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .4,
                          child: TextFormField(
                            controller: arrivedDateController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              label: const Text('arrivedDate'),
                            ),
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
                        ),
                        
                        const SizedBox(
                          width: 15,
                        ),
                        */
                        SizedBox(
                          width: 165,
                          child: DropdownMenu<String>(
                            width: 160,
                            initialSelection: '',
                            controller: statusController,
                            requestFocusOnTap: true,
                            label: const Text('Choose Status'),
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  int stCode = await sendFormData();

                  if (stCode == 200 || stCode == 201) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ));
  }
}
