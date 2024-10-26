class MySize {
  int? id;
  String? name;

  MySize({
    this.id,
    this.name,
  });

  // static Category userEmpty() {
  //   return Category(
  //     id: null,
  //     name: '',
  //   );
  // }

  factory MySize.fromJson(Map<String, dynamic> json) {
    return MySize(
      id: json["id"] ?? 0,
      name: json["name"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}
