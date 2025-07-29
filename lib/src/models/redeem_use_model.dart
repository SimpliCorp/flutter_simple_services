class RedeemUseModel {
  String? url;
  String? message;
  String? rid;

  RedeemUseModel({this.url, this.message, this.rid});

  factory RedeemUseModel.fromJson(Map<String, dynamic> json) {
    return RedeemUseModel(
      url: json['url'],
      message: json['message'],
      rid: json['rid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'message': message, 'rid': rid};
  }
}
