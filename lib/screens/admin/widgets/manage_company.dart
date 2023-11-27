import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageCompany extends StatefulWidget {
  ManageCompany({Key? key}) : super(key: key);

  @override
  _ManageCompanyState createState() => _ManageCompanyState();
}

class _ManageCompanyState extends State<ManageCompany> {
  bool companyExists = false;
  @override
  Widget build(BuildContext context) {
    return companyExists
        ? Container(
            margin: const EdgeInsets.all(15),
            color: Theme.of(context).primaryColor.withAlpha(200),
            child: Text(
              'My Company Name',
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          )
        : Container(
            margin: const EdgeInsets.all(15),
            color: const Color.fromARGB(255, 254, 111, 101),
            child: Row(
              children: [
                Text(
                  'No Company So far',
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(fontSize: 16),
                    color: Colors.black38,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add),
                )
              ],
            ),
          );
  }
}
