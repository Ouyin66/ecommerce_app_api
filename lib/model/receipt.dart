import 'package:ecommerce_app_api/model/order_status_history.dart';

import 'receipt_variant.dart';

class Receipt {
  int? id;
  int? userId;
  String? address;
  String? phone;
  double? discount;
  String? paymentId;
  bool? interest;
  double? total;
  String? dateCreate;
  List<ReceiptVariant> receiptVariants;
  List<OrderStatusHistory>? orderStatusHistories;

  Receipt({
    this.id,
    this.userId,
    this.address,
    this.phone,
    this.discount,
    this.paymentId,
    this.interest,
    this.total,
    this.dateCreate,
    required this.receiptVariants,
    this.orderStatusHistories,
  });

  double get totalReceipt =>
      receiptVariants.fold(0, (sum, item) => sum + total!);

  int get totalItem => receiptVariants.length;

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json["id"] ?? 0,
      userId: json["userId"] ?? 0,
      address: json["address"] ?? '',
      phone: json["phone"] ?? '',
      discount: json["discount"] ?? 0.0,
      paymentId: json["paymentId"] ?? '',
      interest: json["interest"] ?? false,
      total: json["total"] ?? 0.0,
      dateCreate: json["dateCreate"] ?? '',
      receiptVariants: (json["receiptVariants"] as List<dynamic>? ?? [])
          .map((rv) => ReceiptVariant.fromJson(rv))
          .toList(),
      orderStatusHistories:
          (json["orderStatusHistories"] as List<dynamic>? ?? [])
              .map((osh) => OrderStatusHistory.fromJson(osh))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      "id": id,
      "userId": userId,
      "address": address,
      "phone": phone,
      "discount": discount,
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
