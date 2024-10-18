import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';

class API {
  final Dio _dio = Dio();
  String baseUrl = "http://192.168.1.126:5132";

  API() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = Duration(seconds: 10); // Thay đổi ở đây
    _dio.options.receiveTimeout = Duration(seconds: 10); // Thay đổi ở đây
  }

  Dio get sendRequest => _dio;
}

class APIRepository {
  API api = API();

  Map<String, dynamic> header(String token) {
    return {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $token'
    };
  }

  Future<User> login(String email, String password) async {
    try {
      final response =
          await api.sendRequest.get('/User/Login', queryParameters: {
        'email': email,
        'password': password,
      });
      // final body = FormData.fromMap({'email': email, 'password': password});

      // final response = await api.sendRequest.get('/User/Login',
      //     options: Options(headers: header('no token')), data: body);

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else if (response.statusCode == 404) {
        throw Exception("User not found: ${response.data['message']}");
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized: ${response.data['message']}");
      } else {
        throw Exception("Unexpected error: ${response.statusCode}");
      }
    } catch (e) {
      print("Login exception: $e");
      throw Exception("Login failed: $e");
    }
  }

  // Future<User> current(String token) async {
  //   try {
  //     Response res = await api.sendRequest
  //         .get('/Auth/current', options: Options(headers: header(token)));
  //     return User.fromJson(res.data);
  //   } catch (ex) {
  //     rethrow;
  //   }
  // }
}
