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
  ];

  // Login method
  Future<MessageResponse?> login(String email, String password) async {
    for (var baseurl in baseurls) {
      Uri uri = Uri.parse("$baseurl/User/Login").replace(queryParameters: {
        'email': email,
        'password': password,
      });

      try {
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          return MessageResponse(user: User.fromJson(data['user']));
        } else if (response.statusCode == 404) {
          return MessageResponse(errorMessageEmail: "Người dùng không tồn tại");
        } else if (response.statusCode == 401) {
          return MessageResponse(errorMessagePassword: "Mật khẩu không đúng");
        } else {
          return MessageResponse(errorMessage: "Đã xảy ra lỗi không xác định");
        }
      } catch (e) {
        print("Lỗi: $e với baseurl: $baseurl");
      }
    }
    return MessageResponse(errorMessage: "Không thể kết nối đến máy chủ.");
  }

  // Register method
  Future<MessageResponse?> register(
      String name, String email, String password) async {
    for (var baseurl in baseurls) {
      Uri uri = Uri.parse("$baseurl/User/Register").replace(queryParameters: {
        'email': email,
        'password': password,
        'name': name,
      });

      try {
        final response = await http.post(uri);

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          return MessageResponse(user: User.fromJson(data['user']));
        } else if (response.statusCode == 400) {
          return MessageResponse(errorMessageEmail: "Email đã được sử dụng");
        } else {
          return MessageResponse(errorMessage: "Đã xảy ra lỗi không xác định");
        }
      } catch (e) {
        print("Lỗi: $e với baseurl: $baseurl");
      }
    }
    return MessageResponse(errorMessage: "Không thể kết nối đến máy chủ.");
  }

  // Forgot Password method
  Future<MessageResponse?> forgotPassword(String email) async {
    for (var baseurl in baseurls) {
      Uri uri =
          Uri.parse("$baseurl/User/ForgotPassword").replace(queryParameters: {
        'email': email,
      });

      try {
        final response = await http.post(uri);

        if (response.statusCode == 200) {
          return MessageResponse(
              successMessage: "Mật khẩu đã được gửi qua email của bạn");
        } else if (response.statusCode == 404) {
          return MessageResponse(errorMessageEmail: 'Email không tồn tại');
        } else {
          return MessageResponse(errorMessage: "Đã xảy ra lỗi không xác định");
        }
      } catch (e) {
        print("Lỗi: $e với baseurl: $baseurl");
      }
    }
    return MessageResponse(errorMessage: "Không thể kết nối đến máy chủ.");
  }

  // Signin with Google method
  Future<MessageResponse?> SignInGoogle(String? email, String? providerID,
      String? photoUrl, String? displayName) async {
    for (var baseurl in baseurls) {
      Uri uri =
          Uri.parse("$baseurl/User/GoogleSignIn").replace(queryParameters: {
        'email': email,
        'providerID': providerID,
        'displayName': displayName,
        'photoUrl': photoUrl,
      });

      try {
        final response = await http.post(uri);

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          return MessageResponse(user: User.fromJson(data['existingUser']));
        } else {
          return MessageResponse(errorMessage: "Đã xảy ra lỗi không xác định");
        }
      } catch (e) {
        print("Lỗi: $e với baseurl: $baseurl");
      }
    }
    return MessageResponse(errorMessage: "Không thể kết nối đến máy chủ.");
  }
}
