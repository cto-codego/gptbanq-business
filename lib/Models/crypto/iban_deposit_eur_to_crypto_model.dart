// To parse this JSON data, do
//
//     final ibanDepositEurToCryptoModel = ibanDepositEurToCryptoModelFromJson(jsonString);

import 'dart:convert';

IbanDepositEurToCryptoModel ibanDepositEurToCryptoModelFromJson(String str) => IbanDepositEurToCryptoModel.fromJson(json.decode(str));

String ibanDepositEurToCryptoModelToJson(IbanDepositEurToCryptoModel data) => json.encode(data.toJson());

class IbanDepositEurToCryptoModel {
  int? status;
  String? title;
  String? body;
  String? uniqueId;
  String? message;

  IbanDepositEurToCryptoModel({
    this.status,
    this.title,
    this.body,
    this.uniqueId,
    this.message,
  });

  factory IbanDepositEurToCryptoModel.fromJson(Map<String, dynamic> json) => IbanDepositEurToCryptoModel(
    status: json["status"],
    title: json["title"],
    body: json["body"],
    uniqueId: json["unique_id"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "title": title,
    "body": body,
    "unique_id": uniqueId,
    "message": message,
  };
}
