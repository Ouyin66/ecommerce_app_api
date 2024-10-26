class Category {
  int? id;
  String? name;

  Category({
    this.id,
    this.name,
  });

  // static Category userEmpty() {
  //   return Category(
  //     id: null,
  //     name: '',
  //   );
  // }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
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
