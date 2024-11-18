import 'dart:convert';
import 'package:ecommerce_app_api/model/message_response.dart';
import 'package:ecommerce_app_api/model/promotion.dart';
import 'package:ecommerce_app_api/model/receipt.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app_api/api/api.dart';

class APIReceipt extends APIRepository {
  Future<Receipt?> GetReceipt(int receiptId) async {
    try {
      Uri uri = Uri.parse("$baseurl/Receipt/Get").replace(queryParameters: {
        'receiptId': receiptId.toString(),
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        Receipt receipt = Receipt.fromJson(data['receipt']);

        return receipt;
      } else {
        print("Lỗi khi lấy hóa đơn: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Lỗi: $e");
      return null;
    }
  }

  Future<List<Receipt>?> GetListByUser(int userId) async {
    try {
      Uri uri =
          Uri.parse("$baseurl/Receipt/ListByUserId").replace(queryParameters: {
        'userId': userId.toString(),
      });

      // Gửi yêu cầu GET đến API
      final response = await http.get(uri);

      // Kiểm tra trạng thái phản hồi
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Parse danh sách hóa đơn
        List<Receipt> receipts = (data['receipts'] as List)
            .map((receipts) => Receipt.fromJson(receipts))
            .toList();

        return receipts;
      } else {
        print("Lỗi khi lấy danh sách hóa đơn: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Lỗi: $e");
      return null;
    }
  }

  Future<Receipt?> createReceipt(Receipt receipt) async {
    final url = Uri.parse('$baseurl/Receipt/Insert');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(receipt.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      Receipt receipt = Receipt.fromJson(data);
      print('Receipt created successfully');
      return receipt;
    } else {
      print('Failed to create receipt: ${response.body}');
      print(jsonEncode(receipt.toJson()));
      return null;
    }
  }

  Future<MessageResponse?> updateInterest(
      int receiptId, bool isInterest) async {
    Uri uri =
        Uri.parse("$baseurl/Receipt/IsInterest").replace(queryParameters: {
      'receiptId': receiptId.toString(),
      'isInterest': isInterest.toString(),
    });

    final response = await http.put(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return MessageResponse(successMessage: data['message']);
    } else if (response.statusCode == 404) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return MessageResponse(errorMessage: data['message']);
    } else {
      print('Cập nhật thất bại: ${response.body}');
      return null;
    }
  }
}
