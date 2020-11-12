import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:e_contracter/utils/url.dart';

class Profile {
  String username;
  String shortDescription;
  String jokeRole;
  String longDescription;
  String phone;
  String experience;
  String education;
  String address;

  Profile({
    @required this.username,
    @required this.shortDescription,
    @required this.jokeRole,
    this.longDescription,
    @required this.phone,
    @required this.experience,
    @required this.education,
    @required this.address,
  });
}

class ProfileDetails with ChangeNotifier {
  Dio dio = Dio();
  String _token;
  Response response;
  Map<String, Profile> _profile = {};
  final storage = FlutterSecureStorage();

  Map<String, Profile> get profile {
    return {..._profile};
  }

  Future<void> createProfile(
    String nikename,
    String shortDescription,
    String jobRole,
    String experience,
    String phone,
    String age,
    String education,
    String address,
  ) async {
    _token = await storage.read(key: 'token');

    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $_token';
      response = await dio.post('$url/api/v1/profile', data: {
        'nikename': nikename,
        'shortDescription': shortDescription,
        'JobRole': jobRole,
        'experience': experience,
        'phone': phone,
        'age': age,
        'education': education,
        'address': address
      });

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getCurrentUserProfile() async {
    _token = await storage.read(key: 'token');

    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $_token';
      response = await dio.get('$url/api/v1/profile/current');

      _profile = {
        'data': Profile(
          username: response.data['data']['nikename'],
          shortDescription: response.data['data']['shortDescription'],
          jokeRole: response.data['data']['JobRole'],
          phone: response.data['data']['phone'],
          experience: response.data['data']['experience'],
          education: response.data['data']['education'],
          address: response.data['data']['address'],
        )
      };

      print(profile['data'].experience);
      print(response.data['data']);

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
}
