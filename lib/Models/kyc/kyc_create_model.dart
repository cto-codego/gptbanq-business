// To parse this JSON data, do
//
//     final kycCreateModel = kycCreateModelFromJson(jsonString);

import 'dart:convert';

KycCreateModel kycCreateModelFromJson(String str) => KycCreateModel.fromJson(json.decode(str));

String kycCreateModelToJson(KycCreateModel data) => json.encode(data.toJson());

class KycCreateModel {
  int? status;
  String? message;

  KycCreateModel({
    this.status,
    this.message,
  });

  factory KycCreateModel.fromJson(Map<String, dynamic> json) => KycCreateModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
