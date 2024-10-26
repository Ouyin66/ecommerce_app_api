import 'package:ecommerce_app_api/model/category.dart';
import 'package:ecommerce_app_api/model/color.dart';
import 'package:ecommerce_app_api/model/picture.dart';
import 'package:ecommerce_app_api/model/size.dart';
import 'package:ecommerce_app_api/model/variant.dart';

import 'gender.dart';

class Product {
  int? id;
  int? genderID;
  int? categoryID;
  String? name;
  String? describe;
  double? price;
  double? discount;
  int? amount;
  int? state;
  String? dateCreate;

  Category? nameCategory;
  Gender? nameGender;
  List<MyColor>? listColor;
  List<MySize>? listSize;
  List<Variant>? listVariant;
  List<Picture>? listPicture;

  Product({
    this.id,
    this.genderID,
    this.categoryID,
    this.name,
    this.describe,
    this.price,
    this.discount,
    this.amount,
    this.state,
    this.dateCreate,
    this.nameCategory,
    this.nameGender,
    this.listColor,
    this.listPicture,
    this.listSize,
    this.listVariant,
  });

  static Product userEmpty() {
    return Product(
      id: null,
      genderID: null,
      categoryID: null,
      name: '',
      describe: '',
      price: null,
      discount: null,
      amount: null,
      state: null,
      dateCreate: '',
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"] ?? 0,
      genderID: json["genderId"] ?? 0,
      categoryID: json["categoryId"] ?? 0,
      name: json["namePro"] ?? '',
      describe: json["describe"] ?? '',
      price: json["price"] ?? 0,
      discount: json["discount"] ?? 0,
      amount: json["amount"] ?? 0,
      state: json["state"] ?? 0,
      dateCreate: json["dateCreate"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "genderId": genderID,
      "categoryId":
          categoryID, // Consider not storing the password in plain text
      "name": name,
      "describe": describe,
      "price": price,
      "discount": discount,
      "amount": amount,
      "state": state,
      "dateCreate": dateCreate,
    };
  }

  // void getInformation() async {
  //   nameGender = await APIGender().getGender(genderID!);
  //   listPicture = await APIProduct().getPicturesByProduct(id!);
  //   listVariant = await APIProduct().getVariantByProduct(id!);
  // }
}
