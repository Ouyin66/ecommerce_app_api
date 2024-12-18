import 'dart:convert';
import 'package:ecommerce_app_api/model/cart.dart';
import 'package:ecommerce_app_api/model/message_response.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app_api/api/api.dart';

class APICart extends APIRepository {
  Future<List<Cart>?> GetCartByUser(int userId) async {
    try {
      Uri uri =
          Uri.parse("$baseurl/Cart/ListByUserId").replace(queryParameters: {
        'userId': userId.toString(),
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        List<Cart> carts = (data['carts'] as List)
            .map((cartJson) => Cart.fromJson(cartJson))
            .toList();

        return carts;
      } else {
        print("Lỗi khi lấy danh sách giỏ hàng: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Lỗi: $e");
      return [];
    }
  }

  Future<MessageResponse?> Insert(
      int userId, int variantId, int quantity, double price) async {
    try {
      Uri uri = Uri.parse("$baseurl/Cart/Insert").replace(queryParameters: {
        'userId': userId.toString(),
        'variantId': variantId.toString(),
        'quantity': quantity.toString(),
        'price': price.toString(),
      });

      final response = await http.post(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        return MessageResponse(successMessage: data['message']);
      } else {
        final errorData = jsonDecode(response.body);
        return MessageResponse(errorMessage: errorData['message']);
      }
    } catch (e) {
      print("Lỗi: $e");
      return null;
    }
  }

  Future<MessageResponse?> Update(int userId, int oldVariantId, int variantId,
      int quantity, double price) async {
    try {
      Uri uri = Uri.parse("$baseurl/Cart/Update").replace(queryParameters: {
        'userId': userId.toString(),
        'oldVariantId': oldVariantId.toString(),
        'variantId': variantId.toString(),
        'quantity': quantity.toString(),
        'price': price.toString(),
      });

      final response = await http.put(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        Cart? cart = Cart.fromJson(data['cart']);

        return MessageResponse(cart: cart, successMessage: data['message']);
      } else {
        final errorData = jsonDecode(response.body);
        return MessageResponse(errorMessage: errorData['message']);
      }
    } catch (e) {
      print("Lỗi: $e");
      return null;
    }
  }

  Future<MessageResponse?> Delete(int userId, int variantId) async {
    try {
      Uri uri = Uri.parse("$baseurl/Cart/Delete").replace(queryParameters: {
        'userId': userId.toString(),
        'variantId': variantId.toString(),
      });

      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        return MessageResponse(
            cart: Cart.fromJson(data['cart']), successMessage: data['message']);
      } else {
        final errorData = jsonDecode(response.body);
        return MessageResponse(errorMessage: errorData['message']);
      }
    } catch (e) {
      print("Lỗi: $e");
      return null;
    }
  }
}
