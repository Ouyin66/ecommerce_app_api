class MyNotification {
  int? id;
  int? userId;
  String? message;
  String? dateCreated;
  bool? isRead;
  String? type;
  int? referenceId;

  MyNotification({
    this.id,
    this.userId,
    this.message,
    this.dateCreated,
    this.isRead,
    this.type,
    this.referenceId,
  });

  factory MyNotification.fromJson(Map<String, dynamic> json) {
    return MyNotification(
      id: json["id"] ?? 0,
      userId: json["userId"] ?? 0,
      referenceId: json["referenceId"] ?? 0,
      message: json["message"] ?? '',
      dateCreated: json["dateCreated"] ?? '',
      type: json["type"] ?? '',
      isRead: json["isRead"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "referenceId": referenceId,
      "message": message,
      "type": type,
      "isRead": isRead,
    };
  }
}
