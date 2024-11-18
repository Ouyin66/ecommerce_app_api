import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app_api/api/api.dart';

import '../model/message_response.dart';
import '../model/notification.dart';

class APINotification extends APIRepository {
  Future<List<MyNotification>?> GetList(int userId) async {
    try {
      Uri uri = Uri.parse("$baseurl/Nofication/ListByUserId")
          .replace(queryParameters: {
        'userId': userId.toString(),
      });

      // Gửi yêu cầu GET đến API
      final response = await http.get(uri);

      // Kiểm tra trạng thái phản hồi
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Parse danh sách sản phẩm
        List<MyNotification> notifications = (data['dataa'] as List)
            .map(
                (notificationJson) => MyNotification.fromJson(notificationJson))
            .toList();

        return notifications;
      } else {
        print("Lỗi khi lấy danh sách thông báo: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Lỗi: $e");
      return null;
    }
  }

  Future<MessageResponse?> IsRead(int notificationId) async {
    try {
      Uri uri =
          Uri.parse("$baseurl/Nofication/IsRead").replace(queryParameters: {
        'notificationId': notificationId.toString(),
      });

      final response = await http.put(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return MessageResponse(
            notification: MyNotification.fromJson(data['existingNotification']),
            successMessage: data['message']);
      } else if (response.statusCode == 404) {
        final data = jsonDecode(response.body);
        return MessageResponse(errorMessage: data['message']);
      } else {
        return MessageResponse(errorMessage: "Đã xảy ra lỗi không xác định");
      }
    } catch (e) {
      print("Lỗi: $e với baseurl: $baseurl");
      return MessageResponse(errorMessage: "Không thể kết nối đến máy chủ.");
    }
  }
}
