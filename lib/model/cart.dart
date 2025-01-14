import 'package:ecommerce_app_api/model/product.dart';
import 'package:ecommerce_app_api/model/variant.dart';

class Cart {
  int? userId;
  int? variantId;
  int? quantity;
  double? price;
  double? total;

  Product? product;
  Variant? variant;

  Cart({
    this.userId,
    this.variantId,
    this.quantity,
    this.price,
  }) {
    total = (quantity ?? 0) * (price ?? 0);
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      userId: json["userId"] ?? 0,
      variantId: json["variantId"] ?? 0,
      quantity: json["quantity"] ?? 0,
      price: json["price"] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "variantId": variantId,
      "quantity": quantity,
      "price": price,
    };
  }
}
