import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api.dart';
import '../model/message_response.dart';
import '../model/order_status_history.dart';

class APIStatus extends APIRepository {
  Future<List<OrderStatusHistory>?> getStatusByReceipt(int receiptId) async {
    try {
      Uri uri = Uri.parse("$baseurl/OrderStatusHistory/ListByReceiptId")
          .replace(queryParameters: {
        'receiptId': receiptId.toString(),
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        List<OrderStatusHistory> lstStatus = (data['dataa'] as List)
            .map((statusJson) => OrderStatusHistory.fromJson(statusJson))
            .toList();

        return lstStatus;
      } else {
        print("Lỗi khi lấy danh sách trạng thái: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Lỗi: $e");
      return [];
    }
  }

  Future<MessageResponse?> Cancel(int receiptId) async {
    try {
      Uri uri = Uri.parse("$baseurl/OrderStatusHistory/Cancel")
          .replace(queryParameters: {
        'receiptId': receiptId.toString(),
        'notes': "Khách hàng hủy đơn",
      });

      final response = await http.post(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return MessageResponse(
            status: OrderStatusHistory.fromJson(data['orderStatusHistory']));
      } else if (response.statusCode == 400) {
        return MessageResponse(errorMessage: "Đã hủy đơn hàng này");
      } else if (response.statusCode == 404) {
        return MessageResponse(errorMessage: "Không tìm thấy đơn hàng.");
      } else {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print("Lỗi không xác định: ${response.statusCode}");
        print("Lỗi không xác định: ${data['details']}");
        return null;
      }
    } catch (e) {
      print("Lỗi kết nối đến máy chủ: $e");
      return null;
    }
  }

  // Future<MessageResponse?> Insert(
  //     int receiptId, int state, String notes) async {
  //   try {
  //     Uri uri = Uri.parse("$baseurl/OrderStatusHistory/InsertStatus")
  //         .replace(queryParameters: {
  //       'receiptId': receiptId.toString(),
  //       'state': state.toString(),
  //       'notes': notes,
  //     });

  //     final response = await http.post(uri);

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data = jsonDecode(response.body);
  //       return MessageResponse(
  //           status: OrderStatusHistory.fromJson(data['orderStatusHistory']));
  //     } else if (response.statusCode == 400) {
  //       return MessageResponse(
  //           errorMessage: "Đã tồn tại trạng thái với nội dung này");
  //     } else {
  //       print("Lỗi không xác định: ${response.statusCode}");
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Lỗi kết nối đến máy chủ: $e");
  //     return null;
  //   }
  // }

  // Future<MessageResponse?> Update(
  //     int id, int receiptId, int state, String notes) async {
  //   try {
  //     Uri uri = Uri.parse("$baseurl/OrderStatusHistory/UpdateStatus")
  //         .replace(queryParameters: {
  //       'id': id.toString(),
  //       'receiptId': receiptId.toString(),
  //       'state': state.toString(),
  //       'notes': notes.toString(),
  //     });

  //     final response = await http.put(uri);

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data = jsonDecode(response.body);
  //       return MessageResponse(
  //           status: OrderStatusHistory.fromJson(data['orderStatusHistory']));
  //     } else if (response.statusCode == 400) {
  //       return MessageResponse(
  //           errorMessage: "Đã tồn tại trạng thái với nội dung này");
  //     } else {
  //       print("Lỗi không xác định: ${response.statusCode}");
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Lỗi kết nối đến máy chủ: $e");
  //     return null;
  //   }
  // }

  // Future<MessageResponse?> Delete(int id) async {
  //   try {
  //     Uri uri = Uri.parse("$baseurl/OrderStatusHistory/Delete")
  //         .replace(queryParameters: {
  //       'id': id.toString(),
  //     });

  //     final response = await http.delete(uri);

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data = jsonDecode(response.body);
  //       return MessageResponse(
  //           status: OrderStatusHistory.fromJson(data['size']));
  //     } else if (response.statusCode == 404) {
  //       return MessageResponse(
  //           errorMessage: "Không tìm thấy trạng thái với id này");
  //     } else {
  //       print("Lỗi không xác định: ${response.statusCode}");
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Lỗi kết nối đến máy chủ: $e");
  //     return null;
  //   }
  // }
}
