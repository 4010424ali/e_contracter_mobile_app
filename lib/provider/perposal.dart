import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

import 'package:e_contracter/utils/url.dart';

class Perposal {
  String id;
  bool status;
  String accept;
  String title;
  String minPrice;
  String maxPrice;
  int totalTeamMemeber;
  String description;
  String customers;
  Map<String, Object> user;
  String createdAt;

  Perposal(
      {@required this.id,
      @required this.status,
      @required this.accept,
      @required this.title,
      @required this.minPrice,
      @required this.maxPrice,
      @required this.totalTeamMemeber,
      @required this.description,
      @required this.customers,
      @required this.user,
      @required this.createdAt});
}

class Perposals with ChangeNotifier {
  Dio dio = Dio();
  Response response;
  List<Perposal> _perposals = [];
  List<Perposal> _openProject = [];
  List<Perposal> _projectClose = [];
  final storage = FlutterSecureStorage();
  String token;

  List<Perposal> get perposals {
    return [..._perposals];
  }

  List<Perposal> get openProject {
    return [..._openProject];
  }

  List<Perposal> get projectClose {
    return [..._projectClose];
  }

  Future<void> getPerposals(String customerid) async {
    token = await storage.read(key: 'token');
    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $token';
      response = await dio.get('$url/api/v1/perposal/$customerid');

      List<Perposal> loadedPerposla = [];

      print(response.data['data']);

      response.data['data'].forEach((per) {
        loadedPerposla.add(Perposal(
          id: per['_id'],
          status: per['status'],
          accept: per['accept'],
          title: per['title'],
          minPrice: per['minPrice'],
          maxPrice: per['maxPrice'],
          totalTeamMemeber: per['totalTeamMemeber'],
          description: per['description'],
          customers: per['customers'],
          user: per['user'],
          createdAt: per['created'],
        ));
      });

      _perposals = loadedPerposla;

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> deketePerposal(String id) async {
    token = await storage.read(key: 'token');

    final existngPerposalIndex = _perposals.indexWhere((per) => per.id == id);

    _perposals.removeAt(existngPerposalIndex);

    notifyListeners();

    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $token';
      response = await dio.delete('$url/api/v1/perposal/$id');
    } catch (err) {
      throw err;
    }
  }

  Future<void> addPerposal(
    String id,
    String title,
    String description,
    String maxPrice,
    String minPrice,
    String totalTeamMemeber,
  ) async {
    token = await storage.read(key: 'token');

    try {
      response = await dio.post(
        '$url/api/v1/perposal/$id',
        data: {
          'title': title,
          'description': description,
          'maxPrice': maxPrice,
          'minPrice': minPrice,
          'totalTeamMemeber': int.parse(totalTeamMemeber),
        },
      );

      final newProduct = Perposal(
        id: response.data['data']['_id'],
        status: response.data['data']['status'],
        accept: response.data['data']['accept'],
        title: response.data['data']['title'],
        minPrice: response.data['data']['minPrice'],
        maxPrice: response.data['data']['maxPrice'],
        totalTeamMemeber: response.data['data']['totalTeamMemeber'],
        description: response.data['data']['description'],
        customers: response.data['data']['customers'],
        user: response.data['data']['user'],
        createdAt: response.data['data']['created'],
      );
      _perposals.add(newProduct);

      notifyListeners();
    } catch (err) {
      throw err.response.data['error'];
    }
  }

  Future<void> openProjects(String id) async {
    token = await storage.read(key: 'token');

    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $token';
      response = await dio.get('$url/api/v1/perposal?user=$id&accept=yes');

      List<Perposal> loadedOpenPerposal = [];

      response.data['data'].forEach((per) {
        loadedOpenPerposal.add(Perposal(
          id: per['_id'],
          status: per['status'],
          accept: per['accept'],
          title: per['title'],
          minPrice: per['minPrice'],
          maxPrice: per['maxPrice'],
          totalTeamMemeber: per['totalTeamMemeber'],
          description: per['description'],
          customers: per['customers'],
          user: per['user'],
          createdAt: per['created'],
        ));
      });

      _openProject = loadedOpenPerposal;

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> closeProjects(String id) async {
    token = await storage.read(key: 'token');

    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $token';
      response = await dio.get('$url/api/v1/perposal?user=$id&accept=no');

      print(response.data['data']);

      List<Perposal> loadedClosePerposal = [];

      response.data['data'].forEach((per) {
        loadedClosePerposal.add(Perposal(
          id: per['_id'],
          status: per['status'],
          accept: per['accept'],
          title: per['title'],
          minPrice: per['minPrice'],
          maxPrice: per['maxPrice'],
          totalTeamMemeber: per['totalTeamMemeber'],
          description: per['description'],
          customers: per['customers'],
          user: per['user'],
          createdAt: per['created'],
        ));
      });

      _projectClose = loadedClosePerposal;

      notifyListeners();
    } catch (e) {}
  }
}
