import 'dart:convert';

TopicResponse topicResponseFromJson(String str) =>
    TopicResponse.fromJson(json.decode(str));

String topicResponseToJson(TopicResponse data) => json.encode(data.toJson());

class TopicResponse {
  List<Topic>? topics;

  TopicResponse({this.topics});

  TopicResponse copyWith({List<Topic>? topics}) =>
      TopicResponse(topics: topics ?? this.topics);

  factory TopicResponse.fromJson(Map<String, dynamic> json) => TopicResponse(
    topics:
        json["topics"] == null
            ? []
            : List<Topic>.from(json["topics"]!.map((x) => Topic.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "topics":
        topics == null
            ? []
            : List<dynamic>.from(topics!.map((x) => x.toJson())),
  };
}

Topic topicFromJson(String str) => Topic.fromJson(json.decode(str));

String topicToJson(TopicResponse data) => json.encode(data.toJson());

class Topic {
  final String? id;
  final String? name;
  final String? uid;

  Topic({this.id, this.name, this.uid});

  Topic copyWith({String? id, String? name, String? uid}) =>
      Topic(id: id ?? this.id, name: name ?? this.name, uid: uid ?? this.uid);
  factory Topic.fromJson(Map<String, dynamic> json) =>
      Topic(id: json["id"], name: json["name"], uid: json["uid"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "uid": uid};
}
