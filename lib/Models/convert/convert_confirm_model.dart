// To parse this JSON data, do
//
//     final convertConfirmModel = convertConfirmModelFromJson(jsonString);

import 'dart:convert';

ConvertConfirmModel convertConfirmModelFromJson(String str) => ConvertConfirmModel.fromJson(json.decode(str));

String convertConfirmModelToJson(ConvertConfirmModel data) => json.encode(data.toJson());

class ConvertConfirmModel {
  final int? status;
  final String? message;

  ConvertConfirmModel({
    this.status,
    this.message,
  });

  factory ConvertConfirmModel.fromJson(Map<String, dynamic> json) => ConvertConfirmModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
