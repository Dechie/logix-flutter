import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logixx/models/truck.dart';
import 'package:logixx/utils/constants.dart';

import '../../../models/driver.dart';

class MyTruckScreen extends StatefulWidget {
  MyTruckScreen({
    super.key,
    required this.driver,
  });

  final Driver driver;

  @override
  _MyTruckScreenState createState() => _MyTruckScreenState();
}

class _MyTruckScreenState extends State<MyTruckScreen> {
  var truck;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    truck = Truck(
      id: 0,
      name: 'Isuzu',
      driver: widget.driver,
      fuelConsumption: 100,
      mileage: 200,
      companyId: 15,
      createAt: '2023-01-15',
      updatedAt: '2023-01-15',
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            //Image()
            SizedBox(
              width: size.width * .8,
              height: size.height * .4,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 20),
            dataValue(size, 'name', truck.name),
            dataValue(size, 'name', truck.name),
          ],
        ),
      ),
    );
  }

  SizedBox dataValue(Size size, String title, String dataValue) {
    return SizedBox(
      width: size.width * .8,
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 35,
            width: 100,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: GlobalConstants.mainBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(width: 2),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    dataValue,
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 121, 121, 121),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
