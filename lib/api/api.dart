import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/message_response.dart';
import '../model/user.dart';

class APIRepository {
  String baseurl = 'http://10.0.2.2:5132';
}

class APIUser extends APIRepository {
  // Login method
  Future<MessageResponse?> login(String email, String password) async {
    try {
      Uri uri = Uri.parse("$baseurl/User/Login").replace(queryParameters: {
        'email': email,
        'password': password,
      });

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
      return MessageResponse(errorMessage: "Không thể kết nối đến máy chủ.");
    }
  }

  // Register method
  Future<MessageResponse?> register(
      String name, String email, String phone, String password) async {
    try {
      Uri uri = Uri.parse("$baseurl/User/Register").replace(queryParameters: {
        'email': email,
        'phone': phone,
        'password': password,
        'name': name,
      });

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
      return MessageResponse(errorMessage: "Không thể kết nối đến máy chủ.");
    }
  }

  // Forgot Password method
  Future<MessageResponse?> forgotPassword(String email) async {
    try {
      Uri uri =
          Uri.parse("$baseurl/User/ForgotPassword").replace(queryParameters: {
        'email': email,
      });

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
      return MessageResponse(errorMessage: "Không thể kết nối đến máy chủ.");
    }
  }

  // Signin with Google method
  Future<MessageResponse?> signInGoogle(String? email, String? providerID,
      String? photoUrl, String? displayName) async {
    try {
      Uri uri =
          Uri.parse("$baseurl/User/GoogleSignIn").replace(queryParameters: {
        'email': email,
        'providerID': providerID,
        'displayName': displayName,
        'photoUrl': photoUrl,
      });

      final response = await http.post(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return MessageResponse(user: User.fromJson(data['existingUser']));
      } else {
        return MessageResponse(errorMessage: "Đã xảy ra lỗi không xác định");
      }
    } catch (e) {
      print("Lỗi: $e với baseurl: $baseurl");
      return MessageResponse(errorMessage: "Không thể kết nối đến máy chủ.");
    }
  }

  Future<MessageResponse?> changePassword(int id, String? newPassword) async {
    try {
      Uri uri =
          Uri.parse("$baseurl/User/ChangePassword").replace(queryParameters: {
        'id': id.toString(),
        'newPassword': newPassword,
      });

      final response = await http.put(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return MessageResponse(
            user: User.fromJson(data['user']), successMessage: data['message']);
      } else if (response.statusCode == 404) {
        return MessageResponse(errorMessage: "Người dùng không tồn tại");
      } else {
        return MessageResponse(errorMessage: "Đã xảy ra lỗi không xác định");
      }
    } catch (e) {
      print("Lỗi: $e với baseurl: $baseurl");
      return MessageResponse(errorMessage: "Không thể kết nối đến máy chủ.");
    }
  }

  Future<MessageResponse?> updateInformation(User user) async {
    try {
      Uri uri = Uri.parse("$baseurl/User/UpdateInformation")
          .replace(queryParameters: {
        'id': user.id.toString(),
        'name': user.name.toString(),
        'phone': user.phone.toString(),
        'image': user.image.toString(),
        'gender': user.gender.toString(),
      });

      final response = await http.put(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return MessageResponse(
            user: User.fromJson(data['user']), successMessage: data['message']);
      } else if (response.statusCode == 404) {
        return MessageResponse(errorMessage: "Người dùng không tồn tại");
      } else {
        return MessageResponse(errorMessage: "Đã xảy ra lỗi không xác định");
      }
    } catch (e) {
      print("Lỗi: $e với baseurl: $baseurl");
      return MessageResponse(errorMessage: "Không thể kết nối đến máy chủ.");
    }
  }

  Future<MessageResponse?> getUser(int userId) async {
    try {
      Uri uri = Uri.parse("$baseurl/User/Get").replace(queryParameters: {
        'id': userId.toString(),
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return MessageResponse(
            user: User.fromJson(data['user']),
            successMessage: "Lấy thành công");
      } else if (response.statusCode == 404) {
        return MessageResponse(errorMessageEmail: "Người dùng không tồn tại");
      } else {
        return MessageResponse(errorMessage: "Đã xảy ra lỗi không xác định");
      }
    } catch (e) {
      print("Lỗi: $e với baseurl: $baseurl");
      return MessageResponse(errorMessage: "Không thể kết nối đến máy chủ.");
    }
  }
}
