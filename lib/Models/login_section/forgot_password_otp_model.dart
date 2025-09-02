// To parse this JSON data, do
//
//     final forgotPasswordOtpModel = forgotPasswordOtpModelFromJson(jsonString);

import 'dart:convert';

ForgotPasswordOtpModel forgotPasswordOtpModelFromJson(String str) => ForgotPasswordOtpModel.fromJson(json.decode(str));

String forgotPasswordOtpModelToJson(ForgotPasswordOtpModel data) => json.encode(data.toJson());

class ForgotPasswordOtpModel {
  int? status;
  int? isBiometric;
  String? profileimage;
  String? message;

  ForgotPasswordOtpModel({
    this.status,
    this.isBiometric,
    this.profileimage,
    this.message,
  });

  factory ForgotPasswordOtpModel.fromJson(Map<String, dynamic> json) => ForgotPasswordOtpModel(
    status: json["status"],
    isBiometric: json["is_biometric"],
    profileimage: json["profileimage"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "is_biometric": isBiometric,
    "profileimage": profileimage,
    "message": message,
  };
}
