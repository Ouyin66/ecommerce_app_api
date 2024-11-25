import 'dart:convert';
import 'dart:typed_data';

class Picture {
  int? id;
  int? productId;
  Uint8List? image;

  Picture({
    this.id,
    this.productId,
    this.image,
  });

  // static Picture userEmpty() {
  //   return Picture(
  //     id: null,
  //     productId: null,
  //     picture: '',
  //   );
  // }

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      id: json["id"] ?? 0,
      productId: json["productId"] ?? 0,
      image: json["image"] != null
          ? base64Decode(json["image"]) // Giải mã base64 thành Uint8List
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "productId": productId,
      "image": image != null ? base64Encode(image!) : null,
    };
  }
}
