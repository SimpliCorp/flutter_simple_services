import 'dart:convert';

ErrorResponse errorResponseFromJson(String str) =>
    ErrorResponse.fromJson(json.decode(str));

class ErrorResponse {
  final String? id;
  final int? code;
  final String? detail;
  final String? status;

  const ErrorResponse({this.id, this.code, this.detail, this.status});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      id: json['id'] as String?,
      code: json['code'] as int?,
      detail: json['detail'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'code': code, 'detail': detail, 'status': status};
  }
}
