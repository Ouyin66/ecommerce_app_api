import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app_api/api/api.dart';
import 'package:ecommerce_app_api/model/product.dart';

class APIProduct extends APIRepository {
  Future<List<Product>?> GetList() async {
    try {
      Uri uri = Uri.parse("$baseurl/Product/List");

      // Gửi yêu cầu GET đến API
      final response = await http.get(uri);

      // Kiểm tra trạng thái phản hồi
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Parse danh sách sản phẩm
        List<Product> products = (data['data'] as List)
            .map((productJson) => Product.fromJson(productJson))
            .toList();

        return products;
      } else {
        print("Lỗi khi lấy danh sách sản phẩm: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Lỗi: $e");
      return null;
    }
  }

  Future<Product?> Get(int id) async {
    try {
      Uri uri = Uri.parse("$baseurl/Product/Get").replace(queryParameters: {
        'id': id.toString(),
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        Product product = Product.fromJson(data['product']);

        return product;
      } else {
        print("Lỗi khi lấy sản phẩm: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Lỗi: $e");
      return null;
    }
  }

  Future<List<Product>?> FilterProducts(
      String productName, List<int> categoryIds) async {
    try {
      Uri uri = Uri.parse("$baseurl/Product/Filter").replace(queryParameters: {
        'productName': productName,
        'categoryIds': categoryIds.join(',') // Chuyển danh sách thành chuỗi
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        // Chuyển đổi JSON thành danh sách đối tượng Product
        return data.map((item) => Product.fromJson(item)).toList();
      } else if (response.statusCode == 404) {
        print("Không tìm thấy sản phẩm nào");
        return null; // Hoặc có thể trả về một danh sách rỗng
      } else {
        print("Đã xảy ra lỗi không xác định");
        return null;
      }
    } catch (e) {
      print("Lỗi: $e");
      return null;
    }
  }
}
