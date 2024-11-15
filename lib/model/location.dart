class Location {
  int? id;
  int? userId;
  String? name;
  String? address;
  String? dateCreate;
  bool? isDefault;

  Location({
    this.id,
    this.userId,
    this.name,
    this.address,
    this.dateCreate,
    this.isDefault = false,
  });

  // static Gender userEmpty() {
  //   return Gender(
  //     id: null,
  //     name: '',
  //   );
  // }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json["id"] ?? 0,
      userId: json["userId"] ?? 0,
      name: json["name"] ?? '',
      address: json["address"] ?? '',
      dateCreate: json["dateCreate"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "name": name,
      "address": address,
      "dateCreate": dateCreate,
    };
  }
}
