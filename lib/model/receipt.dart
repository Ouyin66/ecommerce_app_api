class Receipt {
  int? id;
  int? userId;
  String? address;
  String? phone;
  String? coupon;
  int? paymentMethod;
  int? state;
  double? total;
  String? dateCreate;

  Receipt({
    this.id,
    this.userId,
    this.address,
    this.phone,
    this.coupon,
    this.paymentMethod,
    this.state,
    this.total,
    this.dateCreate,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json["id"] ?? 0,
      userId: json["userId"] ?? 0,
      address: json["address"] ?? '',
      phone: json["phone"] ?? '',
      coupon: json["coupon"] ?? '',
      paymentMethod: json["paymentMethod"] ?? 0,
      state: json["state"] ?? 0,
      total: json["total"] ?? 0.0,
      dateCreate: json["dateCreate"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "address": address,
      "phone": phone,
      "coupon": coupon,
      "paymentMethod": paymentMethod,
      "state": state,
      "total": total,
      "dateCreate": dateCreate,
    };
  }
}
