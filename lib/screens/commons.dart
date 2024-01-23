import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/admin.dart';
import '../models/auth_user.dart';
import '../models/driver.dart';
import '../models/staff.dart';
import '../services/shared_prefs.dart';
import '../utils/constants.dart';
import 'admin/main/admin_main.dart';
import 'auth/auth_page.dart';
import 'driver/driver_main.dart';
import 'warehouse/warehouse_suspend.dart';

class CommonMethos {
  Container showMoreAccounts(BuildContext context, List<AuthedUser> users) {
    Map<String, List<Color>> colorMap = {
      'admin': [
        const Color.fromARGB(255, 82, 215, 184),
        const Color.fromARGB(255, 0, 109, 98)
      ],
      'staff': [
        const Color.fromARGB(255, 246, 203, 48),
        const Color.fromARGB(255, 156, 120, 11)
      ],
      'driver': [
        const Color.fromARGB(255, 237, 99, 68),
        const Color.fromARGB(255, 151, 13, 3)
      ],
    };
    List<Widget> accountsList = users.take(users.length - 1).map((user) {
      return Row(
        children: [
          TextButton(
            onPressed: () {
              navigateBasedOnRole(context, user.role, users, user);
            },
            child: Text(
              user.name.split(' ').toList().first,
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: GlobalConstants.mainBlue,
                ),
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 45,
            height: 25,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: colorMap[user.role]![
                      1], // the darker color mapping to the user role.
                ),
                color: colorMap[user.role]![0],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Text(
                  user.role,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorMap[user.role]![1],
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();
    return Container(
      //padding: const EdgeInsets.all(3),
      width: MediaQuery.of(context).size.width * .62,
      padding: const EdgeInsets.only(right: 5),
      height: (users.length + 1) * 45,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 3,
            color: GlobalConstants.mainBlue,
          ),),
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...accountsList,
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => const AuthPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
              size: 18,
            ),
            label: Text(
              'New Account',
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: GlobalConstants.mainBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void navigateBasedOnRole(BuildContext context, String role,
      List<AuthedUser> users, AuthedUser user) async {
    print('navigate based on role');
    // taking this user from the middle and putting it at the last of the list

    await writeIntoMemory(users, user);

    if (!context.mounted) {
      return;
    }
    switch (role) {
      case 'admin':
        {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => AdminMainPage(
                admin: Admin.fromAuthedUser(user),
                usersList: users,
              ),
            ),
          );
        }
        break;
      case 'staff':
        {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => WarehouseSuspendPage(
                staff: Staff.fromAuthedUser(user),
                usersList: users,
              ),
            ),
          );
        }
        break;
      case 'driver':
        {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => DriverMainPage(
                driver: Driver.fromAuthedUser(user),
                usersList: users,
              ),
            ),
          );
        }
        break;
    }
  }

  Future<void> writeIntoMemory(List<AuthedUser> users, AuthedUser user) async {
    final preffs = SharedPrefs();

    int index = users.indexOf(user);
    users.removeAt(index);
    users.add(user);
    await preffs.updateUsersList(user);
  }
}
