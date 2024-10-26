import 'package:ecommerce_app_api/model/color.dart';
import 'package:ecommerce_app_api/model/size.dart';

class Variant {
  int? id;
  int? productID;
  int? colorID;
  int? sizeID;
  double? price;
  String? picture;
  int? quantity;
  String? dateCreate;

  double? total;
  MyColor? color;
  MySize? size;

  Variant({
    this.id,
    this.productID,
    this.colorID,
    this.sizeID,
    this.price,
    this.picture,
    this.quantity,
    this.dateCreate,
  });

  static Variant variantEmpty() {
    return Variant(
      id: null,
      productID: null,
      colorID: null,
      sizeID: null,
      price: null,
      picture: '',
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
      picture: json["picture"] == null || json["picture"] == ''
          ? ""
          : json["picture"],
      quantity: json["quantity"] ?? 0,
      dateCreate: json["dateCreate"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "productId": productID,
      "colorId": colorID,
      "sizeId": sizeID,
      "price": price,
      "picture": picture,
      "quantity": quantity,
      "dateCreate": dateCreate,
    };
  }
}
