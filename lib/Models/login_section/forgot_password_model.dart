// To parse this JSON data, do
//
//     final forgotPasswordModel = forgotPasswordModelFromJson(jsonString);

import 'dart:convert';

ForgotPasswordModel forgotPasswordModelFromJson(String str) => ForgotPasswordModel.fromJson(json.decode(str));

String forgotPasswordModelToJson(ForgotPasswordModel data) => json.encode(data.toJson());

class ForgotPasswordModel {
  int? status;
  String? uniqueId;
  String? userId;
  String? message;

  ForgotPasswordModel({
    this.status,
    this.uniqueId,
    this.userId,
    this.message,
  });

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) => ForgotPasswordModel(
    status: json["status"],
    uniqueId: json["unique_id"],
    userId: json["user_id"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "unique_id": uniqueId,
    "user_id": userId,
    "message": message,
  };
}
