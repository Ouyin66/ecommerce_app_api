import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/loginresponse.dart';
import '../model/user.dart';
import 'package:http/http.dart' as http; // Thư viện để gọi HTTP

class APIRepository {
  final List<String> baseurls = [
    'http://10.0.2.2:5132',
    'http://192.168.1.126:5132',
    'http://<other_ip_address>:5132', // Nếu bạn có IP khác cần thử
  ];

  Future<LoginResponse?> login(String email, String password) async {
    for (var baseurl in baseurls) {
      Uri uri = Uri.parse("$baseurl/User/Login").replace(queryParameters: {
        'email': email,
        'password': password,
      });

      try {
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          return LoginResponse(user: User.fromJson(data['user']));
        } else if (response.statusCode == 404) {
          return LoginResponse(errorMessageEmail: "Người dùng không tồn tại");
        } else if (response.statusCode == 401) {
          return LoginResponse(errorMessagePassword: "Mật khẩu không đúng");
        } else {
          return LoginResponse(message: "Đã xảy ra lỗi không xác định");
        }
      } catch (e) {
        print("Lỗi: $e với baseurl: $baseurl");
      }
    }
    return LoginResponse(message: "Không thể kết nối đến máy chủ.");
  }
}
