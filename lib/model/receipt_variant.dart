class ReceiptVariant {
  int? receiptId;
  int? variantId;
  int? quantity;
  double? price;

  double? total;

  ReceiptVariant({
    this.receiptId,
    this.variantId,
    this.quantity,
    this.price,
  }) {
    total = (quantity ?? 0) * (price ?? 0);
  }

  factory ReceiptVariant.fromJson(Map<String, dynamic> json) {
    return ReceiptVariant(
      receiptId: json["receiptId"] ?? 0,
      variantId: json["variantId"] ?? 0,
      quantity: json["quantity"] ?? 0,
      price: json["price"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'receiptId': receiptId,
        'variantId': variantId,
        'quantity': quantity,
        'price': price,
      };
}
