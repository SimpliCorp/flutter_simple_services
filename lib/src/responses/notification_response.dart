import 'dart:convert';

NotificationResponse notificationResponseFromJson(String str) =>
    NotificationResponse.fromJson(json.decode(str));

String notificationResponseToJson(NotificationResponse data) =>
    json.encode(data.toJson());

class NotificationResponse {
  List<Notify>? notifies;

  NotificationResponse({
    this.notifies,
  });

  NotificationResponse copyWith({
    List<Notify>? notifies,
  }) =>
      NotificationResponse(
        notifies: notifies ?? this.notifies,
      );

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      NotificationResponse(
        notifies: json["notifies"] == null
            ? []
            : List<Notify>.from(
                json["notifies"]!.map((x) => Notify.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "notifies": notifies == null
            ? []
            : List<dynamic>.from(notifies!.map((x) => x.toJson())),
      };
}

Notify notifyFromJson(String str) => Notify.fromJson(json.decode(str));
String notifyToJson(Notify data) => json.encode(data.toJson());

class Notify {
  final String? id;
  final String? refId;
  final int? category;
  final String? title;
  final String? body;
  final String? content;
  final String? uid;
  final String? createdAt;
  final String? updatedAt;
  String? readAt;
  final String? deletedAt;

  Notify({
    this.id,
    this.refId,
    this.category,
    this.title,
    this.body,
    this.content,
    this.uid,
    this.createdAt,
    this.updatedAt,
    this.readAt,
    this.deletedAt,
  });

  factory Notify.fromJson(Map<String, dynamic> json) => Notify(
        id: json["id"],
        refId: json["refId"],
        category: json["category"],
        title: json["title"],
        body: json["body"],
        content: json["content"],
        uid: json["uid"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        readAt: json["read_at"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "refId": refId,
        "category": category,
        "title": title,
        "body": body,
        "content": content,
        "uid": uid,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "read_at": readAt,
        "deleted_at": deletedAt,
      };
}
