class Gender {
  int? id;
  String? name;

  Gender({
    this.id,
    this.name,
  });

  // static Gender userEmpty() {
  //   return Gender(
  //     id: null,
  //     name: '',
  //   );
  // }

  factory Gender.fromJson(Map<String, dynamic> json) {
    return Gender(
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
