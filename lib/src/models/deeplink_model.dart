class DeeplinkModel {
  final String url;

  const DeeplinkModel({required this.url});

  factory DeeplinkModel.fromJson(Map<String, dynamic> json) {
    return DeeplinkModel(url: json['url'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'url': url};
  }
}
