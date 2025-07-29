// To parse this JSON data, do
//
//     final responseModel = responseModelFromJson(jsonString);

import 'dart:convert';

ResponseModel responseModelFromJson(String str) =>
    ResponseModel.fromJson(json.decode(str));

String responseModelToJson(ResponseModel data) => json.encode(data.toJson());

class ResponseModel {
  ResponseModel({
    this.id,
    this.code,
    this.detail,
    this.status,
  });

  String? id;
  int? code;
  String? detail;
  String? status;

  ResponseModel copyWith({
    String? id,
    int? code,
    String? detail,
    String? status,
  }) =>
      ResponseModel(
        id: id ?? this.id,
        code: code ?? this.code,
        detail: detail ?? this.detail,
        status: status ?? this.status,
      );

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
        id: json["id"],
        code: json["code"],
        detail: json["detail"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "detail": detail,
        "status": status,
      };
}
