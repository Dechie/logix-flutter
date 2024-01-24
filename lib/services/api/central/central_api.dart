import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logixx/models/admin.dart';
import 'package:logixx/models/company.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/constants.dart';

class Api {
  createCompany(Company company, Admin admin) async {
    var dio = Dio();
    const url = '${AppUrls.baseUrl}/create';
    print(url);
    String? token = admin.token ?? '';
    print(company.toMap());
    print('token: $token');
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

  Future<Company?> getOneCompany(int companyId) async {
    var dio = Dio();

    final url = '${AppUrls.baseUrl}/companies/$companyId';

    Company? searchCompany;

    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data);
        if (response.data != null) {
          var compJson = response.data;

          searchCompany = Company.fromMap(compJson);
        }
      }
    } catch (e) {
      print(e);
    }
    print('${searchCompany!.companyId}: ${searchCompany.name}');
    return searchCompany;
  }

  Future<(List<Company>, int)> fetchCompanies(String token) async {
    var dio = Dio();

    //final prefs = await SharedPreferences.getInstance();
    //final token = prefs.getString('token');
    const url = '${AppUrls.baseUrl}/home';
    int statusCode = 0;

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
      statusCode = response.statusCode ?? -10;

      if (response.statusCode == 200) {
        final jsonData = response.data as List<dynamic>;

        if (jsonData.isNotEmpty) {
          companies = jsonData.map((item) => Company.fromMap(item)).toList();
        }
      } else {
        print(response.statusCode);
        print(response.statusMessage);
      }
    } catch (e) {
      print(e.toString());
    }
    print('companies: ');
    print(companies);
    return (companies, statusCode);
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

  Future<List<Company>> fetchAllCompanies() async {
    var dio = Dio();

    var url = '${AppUrls.baseUrl}/companies';

    List<Company> companies = [];
    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final jsonData = response.data as List<dynamic>;

        if (jsonData.isNotEmpty) {
          companies = jsonData.map((data) => Company.fromMap(data)).toList();
        }
      }
    } catch (e) {
      print(e);
    }

    return companies;
  }

  Future<Company> findCompany(int companyId) async {
    print('companyid: $companyId');
    var dio = Dio();
    var url = '${AppUrls.baseUrl}/companies/$companyId';

    var company;

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final jsonData = response.data;

        if (jsonData != null) {
          company = Company.fromMap(jsonData);
        }
      }
    } catch (e) {
      print(e);
    }

    return company;
  }
}
