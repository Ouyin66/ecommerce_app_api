class Picture {
  int? id;
  int? productId;
  String? image;

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
      image: json["image"] == null || json["image"] == '' ? "" : json["image"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "productId": productId,
      "image": image,
    };
  }
}
