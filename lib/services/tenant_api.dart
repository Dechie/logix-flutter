import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:logixx/models/stock.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/admin.dart';
import '../models/company.dart';
import '../models/project.dart';
import '../models/staff.dart';
import '../utils/constants.dart';
import '../models/route.dart';

class TenantApi {
  Future<(int, List<String>)> fetchProjects(
      int selectTenant, Admin admin) async {
    var dio = Dio();
    int statusCode = 200;

    final url = '${AppUrls.baseUrl}/$selectTenant/projects';
    print(url);
    final token = admin.token ?? '';

    List<String> projects = [];

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        //print(response.data);
        print('fetched successfully');
        final jsonData = response.data as List<dynamic>;

        if (jsonData.isNotEmpty) {
          projects =
              jsonData.map((item) => Project.fromMap(item).name).toList();
        }
      }
      statusCode = response.statusCode!;
    } catch (e) {
      print(e.toString());
    }

    return (statusCode, projects);
  }

  Future<int> createProject(String name, Admin admin, Company company) async {
    var dio = Dio();
    int statusCode = 200;

    final url = '${AppUrls.baseUrl}/${company.companyId}/projects';

    final token = admin.token;

    try {
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'name': name,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = response.data as List<dynamic>;

        if (jsonData.isNotEmpty) {}
        print('added successfully');
      } else if (response.statusCode == 200) {
        print('added successfully');
      }
      statusCode = response.statusCode!;
    } catch (e) {
      print(e.toString());
    }
    return statusCode;
  }

  Future<int> applyStaffToCompany(Company company, Staff staff) async {
    var url = '${AppUrls.baseUrl}/applyStaff';

    var dio = Dio();

    print('staff toek: ${staff.token}');
    int statusCode = 500;
    try {
      final response = await dio.post(
        url,
        data: {
          'company_id': company.companyId,
          'staff_email': staff.email,
        },
        options: Options(headers: {
          'Authorization': 'Bearer ${staff.token}',
          'Content-Type': 'application/json',
        }),
      );
      print(response.data);

      statusCode = response.statusCode!;
    } catch (e) {
      log(e.toString());
      print(e.toString());
    }

    return statusCode;
  }

  Future<(int, List<TravelRoute>)> fetchTravelRoutes(
      int selectTenant, Admin admin) async {
    /*
    var dio = Dio();
    int statusCode = 200;
    statusCode = statusCode + 0;

    var url = '${AppUrls.baseUrl}/$selectTenant/routes';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    List<TravelRoute> routes = [];

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('fetched successfully');
        final jsonData = response.data as List<dynamic>;

        if (jsonData.isNotEmpty) {
          routes = jsonData.map((item) => TravelRoute.fromMap(item)).toList();
        }
      }
      statusCode = response.statusCode!;
    } catch (e) {
      print(e.toString());
    }

    return routes;
    */
    var dio = Dio();
    int statusCode = 200;

    final url = '${AppUrls.baseUrl}/$selectTenant/routes';
    print(url);
    //final prefs = await SharedPreferences.getInstance();
    //final token = prefs.getString('token');
    final token = admin.token ?? '';

    List<TravelRoute> routes = [];

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        //print(response.data);
        print('fetched successfully');
        final jsonData = response.data as List<dynamic>;

        if (jsonData.isNotEmpty) {
          routes = jsonData.map((item) => TravelRoute.fromMap(item)).toList();
        }
      }
      statusCode = response.statusCode!;
    } catch (e) {
      print(e.toString());
    }

    return (statusCode, routes);
  }

  Future<int> createTravelRoute(
      String name, Admin admin, Company company) async {
    var dio = Dio();
    int statusCode = 200;
/*
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'name': name,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = response.data as List<dynamic>;

        if (jsonData.isNotEmpty) {}
        print('added successfully');
      } else if (response.statusCode == 200) {
        print('added successfully');
      }
      statusCode = response.statusCode!;
    } catch (e) {
      print(e.toString());
    }
    return statusCode;
    */

    final url = '${AppUrls.baseUrl}/${company.companyId}/routes';

    final token = admin.token;

    try {
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'name': name,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = response.data as List<dynamic>;

        if (jsonData.isNotEmpty) {}
        print('added successfully');
      } else if (response.statusCode == 200) {
        print('added successfully');
      }
      statusCode = response.statusCode!;
    } catch (e) {
      print(e.toString());
    }
    return statusCode;
  }

  Future<int> createStock(Stock stock, Company company, Staff staff) async {
    var dio = Dio();
    int statusCode = 200;

    final url = '${AppUrls.baseUrl}/${company.companyId}/createStock';

    final token = staff.token;

    try {
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: stock.toMap(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonData = response.data as List<dynamic>;

        if (jsonData.isNotEmpty) {}
        print('added successfully');
      } else if (response.statusCode == 200) {
        print('added successfully');
      }
      statusCode = response.statusCode!;
    } catch (e) {
      print(e.toString());
    }
    return statusCode;
  }
}
