import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class Customer {
  String id;
  String name;
  String description;
  String phone;
  bool status;
  String role;
  int totalSize;
  String pdfUrl;
  String catUrl;
  String cost;
  String buidTime;
  Map<String, dynamic> location;
  String createdAt;
  String user;

  Customer({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.phone,
    @required this.status,
    @required this.role,
    @required this.totalSize,
    @required this.pdfUrl,
    @required this.catUrl,
    @required this.cost,
    @required this.buidTime,
    @required this.location,
    @required this.user,
    @required this.createdAt,
  });
}

class Customers with ChangeNotifier {
  Dio dio = Dio();
  List<Customer> _customers = [];
  Response response;
  String _token;
  String url = 'http://192.168.0.106:5000/api/v1';
  final storage = FlutterSecureStorage();

  List<Customer> get customers {
    return [..._customers];
  }

  Future<void> getCustomers() async {
    try {
      response = await dio.get('$url/customers');

      final List<Customer> loadedCustomer = [];

      response.data['data'].forEach((item) {
        loadedCustomer.add(
          Customer(
            id: item['_id'],
            name: item['name'],
            description: item['description'],
            phone: item['phone'],
            status: item['status'],
            role: item['role'],
            totalSize: item['totalSize'],
            pdfUrl: item['pdfUrl'],
            catUrl: item['carUrl'],
            cost: item['cost'],
            buidTime: item['buidTime'],
            location: item['location'],
            user: item['user'],
            createdAt: item['createdAt'],
          ),
        );
      });

      _customers = loadedCustomer;

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> createProject(
      String name,
      String description,
      String phone,
      String role,
      String totalSize,
      String cost,
      String buidTime,
      String address) async {
    _token = await storage.read(key: 'token');

    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $_token';
      response = await dio.post('$url/customers', data: {
        'name': name,
        'description': description,
        'phone': phone,
        'role': role,
        'totalSize': int.parse(totalSize),
        'cost': cost,
        'buidTime': buidTime,
        'address': address
      });

      print(response.data['data']);
    } catch (err) {
      throw err;
    }
  }

  Future<void> getCompletePerposal(id) async {
    try {
      response = await dio.get('$url/customers?status=false&user=$id');

      final List<Customer> loadedCustomer = [];

      response.data['data'].forEach((item) {
        loadedCustomer.add(
          Customer(
            id: item['_id'],
            name: item['name'],
            description: item['description'],
            phone: item['phone'],
            status: item['status'],
            role: item['role'],
            totalSize: item['totalSize'],
            pdfUrl: item['pdfUrl'],
            catUrl: item['carUrl'],
            cost: item['cost'],
            buidTime: item['buidTime'],
            location: item['location'],
            user: item['user'],
            createdAt: item['createdAt'],
          ),
        );
      });

      _customers = loadedCustomer;

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteCustomer(String id) async {
    _token = await storage.read(key: 'token');

    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $_token';
      response = await dio.delete('$url/customers/$id');

      print(response.data);
    } catch (err) {
      throw err;
    }
  }
}
