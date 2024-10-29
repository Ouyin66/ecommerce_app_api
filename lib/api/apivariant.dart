import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app_api/api/api.dart';
import '../model/variant.dart';

class APIVariant extends APIRepository {
  // Future<List<Category>?> GetList() async {
  //   try {
  //     Uri uri = Uri.parse("$baseurl/Category/List");

  //     // Gửi yêu cầu GET đến API
  //     final response = await http.get(uri);

  //     // Kiểm tra trạng thái phản hồi
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data = jsonDecode(response.body);

  //       // Parse danh sách sản phẩm
  //       List<Category> categories = (data['dataa'] as List)
  //           .map((categoryJson) => Category.fromJson(categoryJson))
  //           .toList();

  //       return categories;
  //     } else {
  //       print("Lỗi khi lấy danh sách loại sản phẩm: ${response.statusCode}");
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Lỗi: $e");
  //     return null;
  //   }
  // }
  Future<Variant?> getVariant(int id) async {
    try {
      Uri uri = Uri.parse("$baseurl/Variant/Get").replace(queryParameters: {
        'id': id.toString(),
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        Variant variant = Variant.fromJson(data['variant']);

        return variant;
      } else {
        print("Lỗi khi lấy sản phẩm: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Lỗi: $e");
      return null;
    }
  }

  Future<List<Variant>?> getVariantByProduct(int productId) async {
    try {
      Uri uri = Uri.parse("$baseurl/Variant/ListByProductId")
          .replace(queryParameters: {
        'productId': productId.toString(),
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        List<Variant> variants = (data['variants'] as List)
            .map((variantJson) => Variant.fromJson(variantJson))
            .toList();

        return variants;
      } else {
        print("Lỗi khi lấy danh sách sản phẩm: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Lỗi: $e");
      return [];
    }
  }
}
