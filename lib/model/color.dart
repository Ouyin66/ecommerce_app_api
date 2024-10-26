class MyColor {
  int? id;
  String? name;
  String? image;

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
      image: json["image"] == null || json["image"] == '' ? "" : json["image"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "image": image,
    };
  }
}
