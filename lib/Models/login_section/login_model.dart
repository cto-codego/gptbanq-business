// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  int? status;
  String? userId;
  String? token;
  int? logincode;
  String? sumsubtoken;
  String? message;

  LoginModel({
    this.status,
    this.userId,
    this.token,
    this.logincode,
    this.sumsubtoken,
    this.message,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    status: json["status"],
    userId: json["user_id"],
    token: json["token"],
    logincode: json["logincode"],
    sumsubtoken: json["sumsubtoken"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "user_id": userId,
    "token": token,
    "logincode": logincode,
    "sumsubtoken": sumsubtoken,
    "message": message,
  };
}