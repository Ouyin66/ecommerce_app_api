import 'dart:convert';
import 'package:ecommerce_app_api/model/color.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app_api/api/api.dart';

class APIColor extends APIRepository {
  Future<List<MyColor>?> getColorByProduct(int productId) async {
    try {
      Uri uri =
          Uri.parse("$baseurl/Color/ListByProductId").replace(queryParameters: {
        'productId': productId.toString(),
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        List<MyColor> colors = (data['colors'] as List)
            .map((colorJson) => MyColor.fromJson(colorJson))
            .toList();

        return colors;
      } else {
        print("Lỗi khi lấy danh sách màu sắc: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Lỗi: $e");
      return [];
    }
  }
}
