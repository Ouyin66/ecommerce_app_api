import 'dart:convert';
import 'dart:typed_data';

class MyColor {
  int? id;
  String? name;
  Uint8List? image;

  MyColor({
    this.id,
    this.name,
    this.image,
  });

  // static Color userEmpty() {
  //   return Color(
  //     id: null,
  //     name: '',
  //     image: '',
  //   );
  // }

  factory MyColor.fromJson(Map<String, dynamic> json) {
    return MyColor(
      id: json["id"] ?? 0,
      name: json["name"] ?? '',
      image: json["image"] != null
          ? base64Decode(json["image"]) // Giải mã base64 thành Uint8List
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "image": image != null ? base64Encode(image!) : null,
    };
  }
}
