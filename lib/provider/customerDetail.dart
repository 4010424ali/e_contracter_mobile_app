import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';

class CustomerDetail {
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
  String userName;
  String image;

  CustomerDetail(
      {@required this.id,
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
      @required this.image,
      @required this.userName});
}

class CustomerDetails with ChangeNotifier {
  Dio dio = Dio();
  Response response;
  String url = 'http://192.168.0.106:5000/api/v1';
  Map<String, CustomerDetail> _customerDetail = {};

  Map<String, CustomerDetail> get customerDetail {
    return {..._customerDetail};
  }

  Future<void> getSignleCustomer(String id) async {
    try {
      response = await dio.get('$url/customers/$id');
      Map<String, CustomerDetail> loadedCustomerDetails = {};
      loadedCustomerDetails = {
        'data': CustomerDetail(
            id: response.data['deta']['customer']['_id'],
            name: response.data['deta']['customer']['name'],
            description: response.data['deta']['customer']['description'],
            phone: response.data['deta']['customer']['phone'],
            status: response.data['deta']['customer']['status'],
            role: response.data['deta']['customer']['role'],
            totalSize: response.data['deta']['customer']['totalSize'],
            pdfUrl: response.data['deta']['customer']['pdfUrl'],
            catUrl: response.data['deta']['customer']['catUrl'],
            cost: response.data['deta']['customer']['cost'],
            buidTime: response.data['deta']['customer']['buidTime'],
            location: response.data['deta']['customer']['location'],
            user: response.data['deta']['customer']['user'],
            createdAt: response.data['deta']['customer']['createdAt'],
            image: response.data['deta']['user']['image'],
            userName: response.data['deta']['user']['name'])
      };
      _customerDetail = loadedCustomerDetails;

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
}
