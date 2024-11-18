import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app_api/api/api.dart';
import '../model/size.dart';

class APISize extends APIRepository {
  Future<List<MySize>?> getSizeByProduct(int productId) async {
    try {
      Uri uri =
          Uri.parse("$baseurl/Size/ListByProductId").replace(queryParameters: {
        'productId': productId.toString(),
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        List<MySize> sizes = (data['sizes'] as List)
            .map((sizeJson) => MySize.fromJson(sizeJson))
            .toList();

        return sizes;
      } else {
        print("Lỗi khi lấy danh sách kích cỡ: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Lỗi: $e");
      return [];
    }
  }
}
