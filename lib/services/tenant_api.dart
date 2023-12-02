import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/admin.dart';
import '../models/company.dart';
import '../utils/constants.dart';
import '../models/route.dart';

class TenantApi {
  Future<(int, List<String>)> fetchProjects(int selectTenant) async {
    var dio = Dio();
    int statusCode = 200;

    const url = '${AppUrls.baseUrl}/2/projects';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

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
        print('fetched successfully');
        final jsonData = response.data as List<dynamic>;

        if (jsonData.isNotEmpty) {
          projects = jsonData.map((item) => item['name'].toString()).toList();
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

  Future<List<TravelRoute>> fetchTravelRoutes(int selectTenant) async {
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
  }

  Future<int> createTravelRoute(String name) async {
    var dio = Dio();
    int statusCode = 200;

    const url = '${AppUrls.baseUrl}/2/routes';

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
  }
}
