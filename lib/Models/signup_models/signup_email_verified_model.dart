// To parse this JSON data, do
//
//     final signupEmailVerifiedModel = signupEmailVerifiedModelFromJson(jsonString);

import 'dart:convert';

SignupEmailVerifiedModel signupEmailVerifiedModelFromJson(String str) => SignupEmailVerifiedModel.fromJson(json.decode(str));

String signupEmailVerifiedModelToJson(SignupEmailVerifiedModel data) => json.encode(data.toJson());

class SignupEmailVerifiedModel {
  int? status;
  String? sumsubtoken;
  String? message;

  SignupEmailVerifiedModel({
    this.status,
    this.sumsubtoken,
    this.message,
  });

  factory SignupEmailVerifiedModel.fromJson(Map<String, dynamic> json) => SignupEmailVerifiedModel(
    status: json["status"],
    sumsubtoken: json["sumsubtoken"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "sumsubtoken": sumsubtoken,
    "message": message,
  };
}