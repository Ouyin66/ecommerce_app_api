import 'receipt_variant.dart';

class Receipt {
  int? id;
  int? userId;
  String? address;
  String? phone;
  String? coupon;
  int? paymentMethod;
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
    this.paymentMethod,
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
      coupon: json["coupon"] ?? '',
      paymentMethod: json["paymentMethod"] ?? 0,
      interest: json["interest"] ?? 0,
      total: json["total"] ?? 0.0,
      dateCreate: json["dateCreate"] ?? '',
      receiptVariants: json["ReceiptVariants"] ?? [],
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
      "state": interest,
      "total": total,
      "dateCreate": dateCreate,
    };
  }
}
