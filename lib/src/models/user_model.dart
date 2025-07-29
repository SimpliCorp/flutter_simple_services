// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserTokenModel userModelFromJson(String str) =>
    UserTokenModel.fromJson(json.decode(str));

String userModelToJson(UserTokenModel data) => json.encode(data.toJson());

class UserTokenModel {
  UserTokenModel({
    this.token,
  });

  Token? token;

  UserTokenModel copyWith({
    Token? token,
  }) =>
      UserTokenModel(
        token: token ?? this.token,
      );

  factory UserTokenModel.fromJson(Map<String, dynamic> json) => UserTokenModel(
        token: json["token"] == null ? null : Token.fromJson(json["token"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token?.toJson(),
      };
}

class Token {
  Token({
    this.accessToken,
    this.refreshToken,
    this.created,
    this.expiry,
  });

  String? accessToken;
  String? refreshToken;
  String? created;
  String? expiry;

  Token copyWith({
    String? accessToken,
    String? refreshToken,
    String? created,
    String? expiry,
  }) =>
      Token(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
        created: created ?? this.created,
        expiry: expiry ?? this.expiry,
      );

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
        created: json["created"],
        expiry: json["expiry"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "refresh_token": refreshToken,
        "created": created,
        "expiry": expiry,
      };
}
