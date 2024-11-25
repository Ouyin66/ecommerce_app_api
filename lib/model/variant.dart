import 'dart:convert';
import 'dart:typed_data';

import 'package:ecommerce_app_api/model/color.dart';
import 'package:ecommerce_app_api/model/product.dart';
import 'package:ecommerce_app_api/model/size.dart';

class Variant {
  int? id;
  int? productID;
  int? colorID;
  int? sizeID;
  double? price;
  Uint8List? picture;
  int? quantity;
  String? dateCreate;

  double? total;
  MyColor? color;
  MySize? size;
  Product? product;

  Variant({
    this.id,
    this.productID,
    this.colorID,
    this.sizeID,
    this.price,
    this.picture,
    this.quantity,
    this.dateCreate,
    this.size,
    this.color,
    this.product,
  });

  static Variant variantEmpty() {
    return Variant(
      id: null,
      productID: null,
      colorID: null,
      sizeID: null,
      price: null,
      picture: null,
      quantity: null,
      dateCreate: '',
    );
  }

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json["id"] ?? 0,
      productID: json["productId"] ?? 0,
      colorID: json["colorId"] ?? 0,
      sizeID: json["sizeId"] ?? 0,
      price: json["price"] ?? 0,
      picture: json["picture"] != null
          ? base64Decode(json["picture"]) // Giải mã base64 thành Uint8List
          : null,
      quantity: json["quantity"] ?? 0,
      dateCreate: json["dateCreate"] ?? '',
      color: json["color"] != null ? MyColor.fromJson(json["color"]) : null,
      size: json["size"] != null ? MySize.fromJson(json["size"]) : null,
      product:
          json["product"] != null ? Product.fromJson(json["product"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "productId": productID,
      "colorId": colorID,
      "sizeId": sizeID,
      "price": price,
      "picture": picture != null ? base64Encode(picture!) : null,
      "quantity": quantity,
      "dateCreate": dateCreate,
    };
  }
}
