import 'dart:convert';
import 'package:ecommerce_app_api/model/color.dart';
import 'package:ecommerce_app_api/model/picture.dart';
import 'package:ecommerce_app_api/model/size.dart';
import 'package:ecommerce_app_api/model/variant.dart';
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
        List<Product> products = (data['dataa'] as List)
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

  Future<List<Picture>?> getPicturesByProduct(int productId) async {
    try {
      Uri uri = Uri.parse("$baseurl/Picture/ListByProductId")
          .replace(queryParameters: {
        'productId': productId.toString(),
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Parse danh sách hình ảnh
        List<Picture> pictures = (data['picutures'] as List)
            .map((pictureJson) => Picture.fromJson(pictureJson))
            .toList();

        return pictures;
      } else {
        print("Lỗi khi lấy danh sách hình ảnh: ${response.statusCode}");
        return []; // Trả về danh sách trống nếu có lỗi
      }
    } catch (e) {
      print("Lỗi: $e");
      return []; // Trả về danh sách trống nếu có ngoại lệ
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

        // Parse danh sách hình ảnh
        List<Variant> variants = (data['variants'] as List)
            .map((variantJson) => Variant.fromJson(variantJson))
            .toList();

        return variants;
      } else {
        print("Lỗi khi lấy danh sách hình ảnh: ${response.statusCode}");
        return []; // Trả về danh sách trống nếu có lỗi
      }
    } catch (e) {
      print("Lỗi: $e");
      return []; // Trả về danh sách trống nếu có ngoại lệ
    }
  }

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
        print("Lỗi khi lấy danh sách hình ảnh: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Lỗi: $e");
      return [];
    }
  }

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
        print("Lỗi khi lấy danh sách hình ảnh: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Lỗi: $e");
      return [];
    }
  }
}
