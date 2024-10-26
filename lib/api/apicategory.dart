import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app_api/api/api.dart';
import '../model/category.dart';

class APICategory extends APIRepository {
  Future<List<Category>?> GetList() async {
    try {
      Uri uri = Uri.parse("$baseurl/Category/List");

      // Gửi yêu cầu GET đến API
      final response = await http.get(uri);

      // Kiểm tra trạng thái phản hồi
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Parse danh sách sản phẩm
        List<Category> categories = (data['dataa'] as List)
            .map((categoryJson) => Category.fromJson(categoryJson))
            .toList();

        return categories;
      } else {
        print("Lỗi khi lấy danh sách loại sản phẩm: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Lỗi: $e");
      return null;
    }
  }

  // Future<List<MySize>?> getSizeByProduct(int productId) async {
  //   try {
  //     Uri uri =
  //         Uri.parse("$baseurl/Size/ListByProductId").replace(queryParameters: {
  //       'productId': productId.toString(),
  //     });

  //     final response = await http.get(uri);

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data = jsonDecode(response.body);

  //       List<MySize> sizes = (data['sizes'] as List)
  //           .map((sizeJson) => MySize.fromJson(sizeJson))
  //           .toList();

  //       return sizes;
  //     } else {
  //       print("Lỗi khi lấy danh sách hình ảnh: ${response.statusCode}");
  //       return [];
  //     }
  //   } catch (e) {
  //     print("Lỗi: $e");
  //     return [];
  //   }
  // }
}
