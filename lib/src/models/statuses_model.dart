class StatusesModel {
  StatusesModel({this.unread});

  String? unread;

  StatusesModel copyWith({String? unread}) =>
      StatusesModel(unread: unread ?? this.unread);

  factory StatusesModel.fromJson(Map<String, dynamic> json) =>
      StatusesModel(unread: json["unread"]);

  Map<String, dynamic> toJson() => {"unread": unread};
}
