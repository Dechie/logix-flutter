import 'package:dio/dio.dart';
import 'package:logixx/models/admin.dart';
import 'package:logixx/models/company.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class Api {
  createCompany(Company company, Admin admin) async {
    var dio = Dio();
    const url = '${AppUrls.baseUrl}/create';
    print(url);
    String? token = admin.token ?? '';
    print(token);

    final userData = company.toMap();

    try {
      final response = await dio.post(
        url,
        data: userData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        print(response.data);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<Company>> fetchCompanies(String token) async {
    var dio = Dio();

    //final prefs = await SharedPreferences.getInstance();
    //final token = prefs.getString('token');
    const url = '${AppUrls.baseUrl}/home';

    List<Company> companies = [];

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
        final jsonData = response.data as List<dynamic>;

        if (jsonData.isNotEmpty) {
          companies = jsonData.map((item) => Company.fromMap(item)).toList();
        }
      }
    } catch (e) {
      print(e.toString());
    }
    //print(companies);
    return companies;
  }

  Future<(int, List<String>)> fetchProjects(int selectTenant) async {
    var dio = Dio();
    int statusCode = 200;

    const url = '${AppUrls.baseUrl}/2';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    List<String> companies = [];

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
          companies = jsonData.map((item) => item['name'].toString()).toList();
        }
      }
      statusCode = response.statusCode!;
    } catch (e) {
      print(e.toString());
    }

    print(companies);
    return (statusCode, companies);
  }
}
