class OrderStatusHistory {
  int? id;
  int? receiptId;
  int? state;
  String? notes;
  String? timestamp;

  OrderStatusHistory({
    this.id,
    this.receiptId,
    this.state,
    this.notes,
    this.timestamp,
  });

  factory OrderStatusHistory.fromJson(Map<String, dynamic> json) {
    return OrderStatusHistory(
      id: json["id"] ?? 0,
      receiptId: json["receiptId"] ?? 0,
      state: json["state"] ?? 0,
      notes: json["notes"] ?? '',
      timestamp: json["timestamp"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "receiptId": receiptId,
      "state": state,
      "notes": notes,
    };
  }
}
