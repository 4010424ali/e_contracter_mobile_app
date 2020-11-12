import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

class User {
  @required
  String userId;
  @required
  String name;
  @required
  String email;
  @required
  String imageUrl;
  @required
  String createdAt;

  User({
    this.userId,
    this.name,
    this.email,
    this.imageUrl,
    this.createdAt,
  });
}

class Auth with ChangeNotifier {
  Map<String, String> _user = {};
  String token;
  Response response;
  String _token;
  Dio dio = new Dio();
  String url = 'http://192.168.0.106:5000/api/v1';
  final storage = FlutterSecureStorage();

  Map<String, String> get user {
    return {..._user};
  }

  Future<void> login(String email, String password) async {
    try {
      response = await dio.post('$url/auth/login',
          data: {'email': email, "password": password});

      _token = response.data['token'];

      await storage.write(key: 'token', value: _token);

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> getUser() async {
    token = await storage.read(key: 'token');
    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $token';
      response = await dio.get('$url/auth/me');
      Map<String, String> loadedUser = {};

      loadedUser = {
        'email': response.data['data']['email'],
        'image': response.data['data']['image'],
        'name': response.data['data']['name'],
        "userId": response.data['data']['_id'],
        'role': response.data['data']['role'],
        "createdAt": response.data['data']['createdAt']
      };

      _user = loadedUser;

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> register(
      String name, String email, String password, String role) async {
    try {
      response = await dio.post('$url/auth/register', data: {
        'name': name,
        'email': email,
        'role': role,
        'password': password
      });

      _token = response.data['token'];

      await storage.write(key: 'token', value: _token);

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> logout() async {
    await storage.deleteAll();
    _user = {};
    notifyListeners();
  }

  Future<void> uploadImage(File file) async {
    try {
      String fileName = basename(file.path);

      // Set the Authorization Header
      Map<String, String> headers = {"Authorization": "Bearer $token"};

      // Define the request and Url where post the data
      var request = http.MultipartRequest("PUT", Uri.parse('$url/auth/upload'));

      // Add the header;
      request.headers.addAll(headers);

      // Bring the file in Multipart data
      var pic = await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: fileName,
        contentType: MediaType('image', 'png'),
      );

      // add the image to files
      request.files.add(pic);

      // Send the data
      var response = await request.send();

      // Get the stream back
      var responseData = await response.stream.toBytes();

      // Make the data reader into frontend of mobile
      var responseString = String.fromCharCodes(responseData);

      // convert the data into Map
      var valueMap = json.decode(responseString);

      // update the frontend with new image
      _user['image'] = valueMap['data'];

      notifyListeners();
    } catch (e) {
      print(e.response.data);
    }
  }

  void greeting() {
    print("working in office");
  }
}
