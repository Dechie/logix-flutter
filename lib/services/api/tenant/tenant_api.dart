import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:logixx/models/stock.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/admin.dart';
import '../../../models/company.dart';
import '../../../models/driver.dart';
import '../../../models/project.dart';
import '../../../models/route.dart';
import '../../../models/staff.dart';
import '../../../models/warehouse.dart';
import '../../../utils/constants.dart';

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

  /*
  Future<int> applyStaffToCompany(Company company, Staff staff) async {
    var dio = Dio();

    print('staff toek: ${staff.token}');
    int statusCode = 500;
    try {
      print(response.data);

      statusCode = response.statusCode!;
    } catch (e) {
      log(e.toString());
      print(e.toString());
    }

    return statusCode;
  }
  */

  Future<int> applyEmployeeToCompany(
      {required Company company,
      required String employeeRole,
      Driver? theDriver,
      Staff? theStaff}) async {
    var dio = Dio();
    var url = '';
    late Response response;
    //print('staff token: ${driver.token}');
    int statusCode = 500;
    try {
      switch (employeeRole) {
        case "driver":
          {
            url = '${AppUrls.baseUrl}/staff/applyDriver';
            Driver driver = theDriver!;
            response = await dio.post(
              url,
              data: {
                'company_id': company.companyId,
                'staff_email': driver.email,
              },
              options: Options(headers: {
                'Authorization': 'Bearer ${driver.token}',
                'Content-Type': 'application/json',
              }),
            );
          }
          break;
        case "staff":
          {
            url = '${AppUrls.baseUrl}/staff/applyStaff';
            Staff staff = theStaff!;
            response = await dio.post(
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
          }
          break;
      }

      print(response.data);

      statusCode = response.statusCode!;
    } catch (e) {
      //log(e.toString());
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
        print(response.data);
      }
      statusCode = response.statusCode!;
    } catch (e) {
      print(e.toString());
    }
    return statusCode;
  }

  Future<List<Stock>> fetchStocks(company, staff) async {
    var dio = Dio();
    int statusCode = 200;

    List<Stock> stocks = [];

    final url = '${AppUrls.baseUrl}/${company.companyId}/listStocks';
    print(url);
    //final prefs = await SharedPreferences.getInstance();
    //final token = prefs.getString('token');
    final token = staff.token ?? '';

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
          stocks = jsonData.map((item) => Stock.fromMap(item)).toList();
        }
      }
      statusCode = response.statusCode!;
    } catch (e) {
      print(e.toString());
    }

    return stocks;
  }

  Future<bool> sendStaffNotif(int companyId, Staff staff) async {
    var dio = Dio();

    final url = '${AppUrls.baseUrl}/$companyId/applyWarehouse';
    try {
      final token = staff.token;
      final response = await dio.post(
        url,
        data: {
          'company_id': companyId,
          'staff_email': staff.email,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }

  Future<bool> sendEmployeeNotif({
    required int companyId,
    required String employeeRole,
    Driver? theDriver,
    Staff? theStaff,
  }) async {
    var dio = Dio();

    var url = '${AppUrls.baseUrl}/$companyId/notifyAdmin';

    switch (employeeRole) {
      case 'driver':
        {
          Driver driver = theDriver!;
          url += 'notifyAdmin';
          var token = driver.token;

          try {
            final response = await dio.post(
              url,
              data: {
                'company_id': companyId,
                'staff_email': driver.email,
              },
              options: Options(
                headers: {
                  'Authorization': 'Bearer $token',
                  'Content-Type': 'application/json',
                },
              ),
            );

            if (response.statusCode == 200) {
              return true;
            }
          } catch (e) {
            print(e);
          }
        }
        break;
      case 'driver':
        {
          Staff staff = theStaff!;
          var token = staff.token;

          try {
            final response = await dio.post(
              url,
              data: {
                'company_id': companyId,
                'staff_email': staff.email,
              },
              options: Options(
                headers: {
                  'Authorization': 'Bearer $token',
                  'Content-Type': 'application/json',
                },
              ),
            );

            if (response.statusCode == 200) {
              return true;
            }
          } catch (e) {
            print(e);
          }
        }
        break;
    }

    return false;
  }

  Future<int> createWarehouse(
      Warehouse warehouse, Admin admin, Company company) async {
    var dio = Dio();
    int statusCode = 200;
    print('onCreate Warehouse function');

    final url = '${AppUrls.baseUrl}/${company.companyId}/warehouses';

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
        data: warehouse.toMap(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print(response.data);
      }
      statusCode = response.statusCode!;
    } catch (e) {
      print(e.toString());
    }
    return statusCode;
  }

  Future<List<Warehouse>> fetchWarehouses(Company company, Admin admin) async {
    var dio = Dio();
    int statusCode = 200;

    List<Warehouse> warehouses = [];

    final url = '${AppUrls.baseUrl}/${company.companyId}/warehouses';

    final token = admin.token ?? '';

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
          warehouses = jsonData.map((item) => Warehouse.fromMap(item)).toList();
        }
      }
      statusCode = response.statusCode!;
    } catch (e) {
      print(e.toString());
    }

    return warehouses;
  }

  Future<List<Driver>> fetchDrivers(int tenantId, Admin admin) async {
    var dio = Dio();
    int statusCode = 200;

    final url = '${AppUrls.baseUrl}/$tenantId/drivers';
    print(url);
    //final prefs = await SharedPreferences.getInstance();
    //final token = prefs.getString('token');
    final token = admin.token ?? '';

    List<Driver> drivers = [];

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
          drivers = jsonData.map((item) => Driver.fromMap(item)).toList();
        }
      }
      statusCode = response.statusCode!;
    } catch (e) {
      print(e.toString());
    }

    return drivers;
  }

  Future<List<Staff>> fetchStaffs(int tenantId, Admin admin) async {
    var dio = Dio();
    int statusCode = 200;

    final url = '${AppUrls.baseUrl}/$tenantId/staffs';
    print(url);
    final token = admin.token ?? '';

    List<Staff> staffs = [];

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
          staffs = jsonData.map((item) => Staff.fromMap(item)).toList();
        }
      }
      statusCode = response.statusCode!;
    } catch (e) {
      print(e.toString());
    }

    return staffs;
  }

  Future<int> applyStaffToWarehouse(
      Warehouse warehouse, Staff staff, Admin admin, Company company) async {
    var dio = Dio();
    int statusCode = 200;
    print('onCreate Warehouse function');

    final url = '${AppUrls.baseUrl}/${company.companyId}/warehouses';

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
        data: warehouse.toMap(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print(response.data);
      }
      statusCode = response.statusCode!;
    } catch (e) {
      print(e.toString());
    }
    return statusCode;
  }

  Future<bool> checkWarehouseToCompany(Company company, Staff staff) async {
    var dio = Dio();
    final url =
        '${AppUrls.baseUrl}/${company.companyId!}/checkStaffAppliedToWarehouse';

    try {
      Response response = await dio.post(
        url,
        data: {
          'staff_email': staff.email,
        },
      );

      if (response.statusCode == 200) {
        print(response.data);
        return response.data['isNull'];
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}
