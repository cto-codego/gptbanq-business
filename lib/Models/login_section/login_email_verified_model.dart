// To parse this JSON data, do
//
//     final loginEmailVerifiedModel = loginEmailVerifiedModelFromJson(jsonString);

import 'dart:convert';

LoginEmailVerifiedModel loginEmailVerifiedModelFromJson(String str) =>
    LoginEmailVerifiedModel.fromJson(json.decode(str));

String loginEmailVerifiedModelToJson(LoginEmailVerifiedModel data) =>
    json.encode(data.toJson());

class LoginEmailVerifiedModel {
  int? status;
  String? profileimage;
  String? message;

  LoginEmailVerifiedModel({
    this.status,
    this.profileimage,
    this.message,
  });

  factory LoginEmailVerifiedModel.fromJson(Map<String, dynamic> json) =>
      LoginEmailVerifiedModel(
        status: json["status"],
        profileimage: json["profileimage"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "profileimage": profileimage,
        "message": message,
      };
}
