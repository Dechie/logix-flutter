import 'package:dio/dio.dart';
import 'package:logixx/models/auth_user.dart';
import 'package:logixx/services/shared_prefs.dart';

import '../models/admin.dart';
import '../models/driver.dart';
import '../models/staff.dart';
import '../utils/constants.dart';

class Auth {
  Future<int> registerAdmin(Admin admin) async {
    var dio = Dio();
    var response = Response(requestOptions: RequestOptions());
    // dio.options.followRedirects = true;
    // dio.options.maxRedirects = 5;
    const url = '${AppUrls.baseUrl}/admin/register';

    try {
      print('making request: ');
      response = await dio.post(
        url,
        data: {
          'name': admin.name,
          'phone': admin.phone,
          'password': admin.password,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 201) {
        print('request successful');
        final token = response.data['token'];
        final id = response.data['id'];

        final preffs = SharedPrefs();

        final authed = AuthedUser(
          id: id,
          name: admin.name,
          role: 'admin',
          token: token,
          phone: admin.phone,
        );

        await preffs.saveUserToPrefs(authed);
      }

      if (response.statusCode == 302) {
        //final newUrl = response.headers['location']![0];

        //final redirectResponse = await dio.get(newUrl);
      }
    } catch (e) {
      print(e.toString());
    }

    return response.statusCode!;
  }

  Future<int> registerStaff(Staff staff) async {
    var dio = Dio();
    var response = Response(requestOptions: RequestOptions());
    final preffs = SharedPrefs();
    dio.options.followRedirects = true;
    dio.options.maxRedirects = 5;
    const url = '${AppUrls.baseUrl}/staff/register';
    print(url);

    int statusCode = 200;
    statusCode = statusCode + 0;

    try {
      print('making request: ');
      response = await dio.post(
        url,
        data: {
          'name': staff.name,
          'phone': staff.phone,
          'password': staff.password,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 201) {
        print('request successful');
        final token = response.data['token'];
        final id = response.data['id'];
        final authed = AuthedUser(
          id: id!,
          name: staff.name,
          role: 'staff',
          token: token,
          phone: staff.phone,
        );

        await preffs.saveUserToPrefs(authed);
      }

      if (response.statusCode == 302) {
        //final newUrl = response.headers['location']![0];

        //final redirectResponse = await dio.get(newUrl);
      }

      statusCode = response.statusCode!;
    } catch (e) {
      print(e.toString());
    }

    return statusCode;
  }

  Future<int> registerDriver(Driver driver) async {
    var dio = Dio();
    var response = Response(requestOptions: RequestOptions());
    final preffs = SharedPrefs();
    dio.options.followRedirects = true;
    dio.options.maxRedirects = 5;
    const url = '${AppUrls.baseUrl}/driver/register';

    int statusCode = 404;
    statusCode = statusCode + 0;

    try {
      print('making request: ');
      response = await dio.post(
        url,
        data: {
          'name': driver.name,
          'phone': driver.phone,
          'password': driver.password,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 201) {
        print('response successful.');
        final token = response.data['token'];
        final id = response.data['id'];
        final authed = AuthedUser(
          id: id!,
          name: driver.name,
          role: 'driver',
          token: token,
          phone: driver.phone,
        );

        await preffs.saveUserToPrefs(authed);
      }

      if (response.statusCode == 302) {
        //final newUrl = response.headers['location']![0];

        //final redirectResponse = await dio.get(newUrl);
      }
      statusCode = response.statusCode!;
    } catch (e) {
      print(e.toString());
    }

    return statusCode;
  }
}
