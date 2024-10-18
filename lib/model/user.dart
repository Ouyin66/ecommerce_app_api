class User {
  int? id;
  String? email;
  String? password;
  String? name;
  String? location;
  String? image;
  int? gender;
  int? state;
  int? role;
  String? providerID;
  String? dateCreate;

  User(
      {this.id,
      this.email,
      this.password,
      this.name,
      this.location,
      this.image,
      this.gender,
      this.state,
      this.role,
      this.providerID,
      this.dateCreate});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        password: json["password"],
        name: json["name"],
        image:
            json["image"] == null || json["image"] == '' ? "" : json['image'],
        location: json["location"],
        gender: json["gender"],
        state: json["state"],
        role: json["role"],
        providerID: json["providerID"],
        dateCreate: json["dateCreate"],
      );
}
