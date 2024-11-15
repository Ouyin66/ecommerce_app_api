import 'dart:convert';
import 'package:ecommerce_app_api/model/loginresponse.dart';
import 'package:ecommerce_app_api/model/promotion.dart';
import 'package:ecommerce_app_api/model/receipt.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app_api/api/api.dart';

class APIReceipt extends APIRepository {
  Future<List<Receipt>?> GetListByUser(int id) async {
    try {
      Uri uri = Uri.parse("$baseurl/Receipts/ListByUserId");

      // Gửi yêu cầu GET đến API
      final response = await http.get(uri);

      // Kiểm tra trạng thái phản hồi
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Parse danh sách sản phẩm
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
    final url = Uri.parse('$baseurl/Receipts/Insert');

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
}
