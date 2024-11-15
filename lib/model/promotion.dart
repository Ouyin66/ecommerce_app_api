class Promotion {
  int? id;
  String? name;
  String? code;
  String? banner;
  String? describe;
  double? perDiscount;
  String? startDate;
  String? endDate;
  String? dateCreate;

  Promotion({
    this.id,
    this.name,
    this.code,
    this.banner,
    this.describe,
    this.perDiscount,
    this.startDate,
    this.endDate,
    this.dateCreate,
  });

  // static Color userEmpty() {
  //   return Color(
  //     id: null,
  //     name: '',
  //     image: '',
  //   );
  // }

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json["id"] ?? 0,
      name: json["name"] ?? '',
      code: json["code"] ?? '',
      banner:
          json["banner"] == null || json["banner"] == '' ? "" : json["banner"],
      describe: json["describe"] ?? '',
      perDiscount: json["perDiscount"] ?? 0,
      startDate: json["startDate"] ?? '',
      endDate: json["endDate"] ?? '',
      dateCreate: json["dateCreate"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "code": code,
      "banner": banner,
      "describe": describe,
      "perDiscount": perDiscount,
      "startDate": startDate,
      "endDate": endDate,
    };
  }
}
