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
    dio.options.followRedirects = true;
    dio.options.maxRedirects = 5;
    const url = '${AppUrls.baseUrl}/admin/register';

    try {
      print('making request: ');
      response = await dio.post(
        url,
        data: {
          'name': admin.name,
          'email': admin.email,
          'password': admin.password,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 201) {
        print('request successful');
        final token = response.data['token'];

        final preffs = SharedPrefs();

        final authed = AuthedUser(
          name: admin.name,
          role: 'admin',
          token: token,
          email: admin.email,
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
          'email': staff.email,
          'password': staff.password,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 201) {
        print('request successful');
        final token = response.data['token'];
        final authed = AuthedUser(
          name: staff.name,
          role: 'staff',
          token: token,
          email: staff.email,
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
          'email': driver.email,
          'password': driver.password,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 201) {
        print('response successful.');
        final token = response.data['token'];

        final authed = AuthedUser(
          name: driver.name,
          role: 'driver',
          token: token,
          email: driver.email,
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
