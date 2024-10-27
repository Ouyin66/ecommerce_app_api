class User {
  int? id;
  String? email;
  String? password;
  String? name;
  String? location;
  String? phone;
  String? image;
  int? gender;
  int? state;
  int? role;
  String? providerID;
  String? dateCreate;

  User({
    this.id,
    this.email,
    this.password,
    this.name,
    this.location,
    this.phone,
    this.image,
    this.gender,
    this.state,
    this.role,
    this.providerID,
    this.dateCreate,
  });

  static User userEmpty() {
    return User(
      id: null,
      email: '',
      password: '',
      name: '',
      location: '',
      phone: '',
      image: '',
      gender: null,
      state: null,
      role: null,
      providerID: '',
      dateCreate: '',
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] ?? 0,
      email: json["email"] ?? '',
      password: json["password"] ?? '',
      name: json["name"] ?? '',
      image: json["image"] == null || json["image"] == '' ? "" : json["image"],
      location: json["location"] ?? '',
      phone: json["phone"] ?? '',
      gender: json["gender"] ?? 0,
      state: json["state"] ?? 0,
      role: json["role"] ?? 0,
      providerID: json["providerID"] ?? '',
      dateCreate: json["dateCreate"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "password": password, // Consider not storing the password in plain text
      "name": name,
      "location": location,
      "phone": phone,
      "image": image,
      "gender": gender,
      "state": state,
      "role": role,
      "providerID": providerID,
      "dateCreate": dateCreate,
    };
  }
}
