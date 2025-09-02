// To parse this JSON data, do
//
//     final cryptoOrderCancelModel = cryptoOrderCancelModelFromJson(jsonString);

import 'dart:convert';

CryptoOrderCancelModel cryptoOrderCancelModelFromJson(String str) => CryptoOrderCancelModel.fromJson(json.decode(str));

String cryptoOrderCancelModelToJson(CryptoOrderCancelModel data) => json.encode(data.toJson());

class CryptoOrderCancelModel {
  int? status;
  String? message;

  CryptoOrderCancelModel({
    this.status,
    this.message,
  });

  factory CryptoOrderCancelModel.fromJson(Map<String, dynamic> json) => CryptoOrderCancelModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
