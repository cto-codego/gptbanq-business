// To parse this JSON data, do
//
//     final userSignupAccountModel = userSignupAccountModelFromJson(jsonString);

import 'dart:convert';

UserSignupAccountModel userSignupAccountModelFromJson(String str) =>
    UserSignupAccountModel.fromJson(json.decode(str));

String userSignupAccountModelToJson(UserSignupAccountModel data) =>
    json.encode(data.toJson());

class UserSignupAccountModel {
  int? status;
  String? email;
  String? message;

  UserSignupAccountModel({
    this.status,
    this.email,
    this.message,
  });

  factory UserSignupAccountModel.fromJson(Map<String, dynamic> json) =>
      UserSignupAccountModel(
        status: json["status"] ?? 0,
        email: json["email"] ?? "",
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "email": email,
    "message": message,
  };
}