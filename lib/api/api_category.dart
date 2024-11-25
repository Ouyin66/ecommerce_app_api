import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app_api/api/api.dart';
import '../model/category.dart';

class APICategory extends APIRepository {
  Future<List<Category>?> GetList() async {
    try {
      Uri uri = Uri.parse("$baseurl/Category/List");

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

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

  Future<Category?> Get(int id) async {
    try {
      Uri uri = Uri.parse("$baseurl/Category/Get").replace(queryParameters: {
        'id': id.toString(),
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Category.fromJson(data['category']);
      } else if (response.statusCode == 404) {
        print("Không tìm thấy loại sản phẩm này");
        return null;
      } else {
        print("Lỗi không xác định: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Lỗi kết nối đến máy chủ: $e");
      return null;
    }
  }
}
