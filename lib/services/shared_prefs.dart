import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_user.dart';
import '../models/company.dart';
import '../models/driver.dart';
import '../models/staff.dart';
import '../models/warehouse.dart';

class SharedPrefs {
  Future<void> saveStaffAppliedStatus(Staff staff, Company company) async {
    final prefs = await SharedPreferences.getInstance();

    final email = staff.email;
    final companyId = company.companyId;

    List<String>? appliedStaffs = prefs.getStringList('appliedStaffs') ?? [];

    appliedStaffs.add('$email:$companyId');
    await prefs.setStringList('appliedStaffs', appliedStaffs);
  }

  Future<List<String>> getAppliedStaffs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? appliedStaffs = prefs.getStringList('appliedStaffs') ?? [];

/*
    use this code whenever you want to refresh registered users

    appliedStaffs = [];
    await prefs.setStringList('appliedStaffs', appliedStaffs);
    */

    return appliedStaffs;
  }

  Future<void> saveWarehouseAssignedStaffs(
      Staff staff, Warehouse warehouse) async {
    final prefs = await SharedPreferences.getInstance();

    final email = staff.email;
    final warehouseName = warehouse.name;

    List<String>? assignedStaffs =
        prefs.getStringList('warehouseAssignedStaffs') ?? [];

    assignedStaffs.add('$email:$warehouseName');
    await prefs.setStringList('warehouseAssignedStaffs', assignedStaffs);
  }

  getWarehouseAssignedStaffs(Staff staff, Warehouse warehouse) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? assignedStaffs =
        prefs.getStringList('warehouseAssignedStaffs') ?? [];

/*
    use this code whenever you want to refresh registered users

    */
    assignedStaffs = [];
    await prefs.setStringList('warehouseAssignedStaffs', assignedStaffs);

    return assignedStaffs;
  }

  Future<void> saveDriverAppliedStatus(Driver driver, Company company) async {
    final prefs = await SharedPreferences.getInstance();

    final email = driver.email;
    final companyId = company.companyId;

    List<String>? appliedDrivers = prefs.getStringList('appliedDrivers') ?? [];

    appliedDrivers.add('$email:$companyId');
    await prefs.setStringList('appliedStaffs', appliedDrivers);
  }

  Future<List<String>> getAppliedDrivers() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? appliedDrivers = prefs.getStringList('appliedDrivers') ?? [];

    /*
    appliedStaffs = [];
    await prefs.setStringList('appliedStaffs', appliedStaffs);
    */
    return appliedDrivers;
  }

  Future<void> saveUserToPrefs(AuthedUser authedUser) async {
    final prefs = await SharedPreferences.getInstance();

    String userStringified = json.encode(authedUser.toJson());

    print('user stringified: $userStringified');

    prefs.setString(authedUser.role, userStringified);

    List<String>? authedUsers = prefs.getStringList('authedUsers');

    authedUsers = authedUsers ?? [];

    /*
    if (authedUsers == null) {
      authedUsers = [];
    }
    */

    authedUsers.add(userStringified);
    await prefs.setStringList('authedUsers', authedUsers);
  }

  Future<List<AuthedUser>> getAuthedFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonStringList = prefs.getStringList('authedUsers');
    List<AuthedUser> users = [];

    if (jsonStringList != null) {
      for (var jsonString in jsonStringList) {
        print(jsonString);
        Map<String, dynamic> jsonMap = json.decode(jsonString);
        users.add(AuthedUser.fromMap(jsonMap));
      }
      //return AuthedUser.fromMap(jsonMap);
    }
    return users;
  }

  Future<void> setAuthedToPrefs(List<AuthedUser> users) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> usersToPrefs = [];

    for (var usr in users) {
      String userStringified = json.encode(usr.toJson());

      usersToPrefs.add(userStringified);
    }

    await prefs.remove('authedUsers');
    await prefs.setStringList('authedUsers', usersToPrefs);
  }

  Future<void> updateUsersList(AuthedUser user) async {
    List<AuthedUser> oldList = await getAuthedFromPrefs();
    AuthedUser userr = AuthedUser(name: '', role: '', token: '', email: '');
    userr = oldList
        .firstWhere((usr) => user.name == usr.name && user.token == usr.token);

    int index = oldList.indexOf(userr);
    oldList.removeAt(index);
    oldList.add(userr);

    await setAuthedToPrefs(oldList);
  }

  void deleteUserFromPrefs(List<AuthedUser> users, AuthedUser user) async {
    users.remove(user);
    List<AuthedUser> oldList = await getAuthedFromPrefs();

    AuthedUser userr = oldList
        .firstWhere((usr) => user.name == usr.name && user.token == usr.token);

    oldList.remove(userr);

    await setAuthedToPrefs(oldList);
  }
}
