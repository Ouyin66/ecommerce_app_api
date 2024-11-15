import 'receipt_variant.dart';

class Receipt {
  int? id;
  int? userId;
  String? address;
  String? phone;
  int? coupon;
  String? paymentId;
  int? interest;
  double? total;
  String? dateCreate;
  List<ReceiptVariant> receiptVariants;

  Receipt({
    this.id,
    this.userId,
    this.address,
    this.phone,
    this.coupon,
    this.paymentId,
    this.interest,
    this.total,
    this.dateCreate,
    required this.receiptVariants,
  });

  double get totalReceipt =>
      receiptVariants.fold(0, (sum, item) => sum + total!);

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json["id"] ?? 0,
      userId: json["userId"] ?? 0,
      address: json["address"] ?? '',
      phone: json["phone"] ?? '',
      coupon: json["coupon"] ?? 0,
      paymentId: json["paymentId"] ?? '',
      interest: json["interest"] ?? 0,
      total: json["total"] ?? 0.0,
      dateCreate: json["dateCreate"] ?? '',
      receiptVariants: (json["receiptVariants"] as List<dynamic>? ?? [])
          .map((rv) => ReceiptVariant.fromJson(rv))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      "id": id,
      "userId": userId,
      "address": address,
      "phone": phone,
      "coupon": coupon,
      "paymentId": paymentId,
      "interest": interest,
      "total": total,
      "dateCreate": dateCreate,
      'receiptVariants': receiptVariants.map((v) => v.toJson()).toList(),
    };

    // Loại bỏ các giá trị null
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
