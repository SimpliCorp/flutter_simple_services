class ActivationFunctionModel {
  String? expiredAt;
  String? timestamp;

  ActivationFunctionModel({this.expiredAt, this.timestamp});

  factory ActivationFunctionModel.fromJson(Map<String, dynamic> json) {
    return ActivationFunctionModel(
      expiredAt: json['expired_at'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'expired_at': expiredAt, 'timestamp': timestamp};
  }
}
