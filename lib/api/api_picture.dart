import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app_api/api/api.dart';
import '../model/picture.dart';

class APIPicture extends APIRepository {
  Future<List<Picture>?> getPicturesByProduct(int productId) async {
    try {
      Uri uri = Uri.parse("$baseurl/Picture/ListByProductId")
          .replace(queryParameters: {
        'productId': productId.toString(),
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        List<Picture> pictures = (data['picutures'] as List)
            .map((pictureJson) => Picture.fromJson(pictureJson))
            .toList();

        return pictures;
      } else {
        print("Lỗi khi lấy danh sách hình ảnh: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Lỗi: $e");
      return [];
    }
  }
}
