// To parse this JSON data, do
//
//     final changePasswordModel = changePasswordModelFromJson(jsonString);

import 'dart:convert';

ChangePasswordModel changePasswordModelFromJson(String str) => ChangePasswordModel.fromJson(json.decode(str));

String changePasswordModelToJson(ChangePasswordModel data) => json.encode(data.toJson());

class ChangePasswordModel {
  int? status;
  String? requestId;
  String? message;

  ChangePasswordModel({
    this.status,
    this.requestId,
    this.message,
  });

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) => ChangePasswordModel(
    status: json["status"],
    requestId: json["request_id"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "request_id": requestId,
    "message": message,
  };
}
