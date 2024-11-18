import 'dart:convert';
import 'package:ecommerce_app_api/model/message_response.dart';
import 'package:ecommerce_app_api/model/promotion.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app_api/api/api.dart';

class APIPromotion extends APIRepository {
  Future<List<Promotion>?> GetListPromotionHasCode() async {
    try {
      Uri uri = Uri.parse("$baseurl/Promotion/ListPromotionHasCode");

      // Gửi yêu cầu GET đến API
      final response = await http.get(uri);

      // Kiểm tra trạng thái phản hồi
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Parse danh sách sản phẩm
        List<Promotion> promotions = (data['dataa'] as List)
            .map((promotions) => Promotion.fromJson(promotions))
            .toList();

        return promotions;
      } else {
        print("Lỗi khi lấy danh sách khuyến mãi: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Lỗi: $e");
      return null;
    }
  }

  Future<MessageResponse?> getPromotionByCode(String code) async {
    try {
      Uri uri = Uri.parse("$baseurl/Promotion/GetPromotionByCode")
          .replace(queryParameters: {
        'code': code,
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        return MessageResponse(
            promotion: Promotion.fromJson(data['promotion']));
      } else if (response.statusCode == 404 || response.statusCode == 400) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return MessageResponse(errorMessage: data['message']);
      } else {
        print("Lỗi khi lấy khuyến mãi: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Lỗi: $e");
      return null;
    }
  }
}
