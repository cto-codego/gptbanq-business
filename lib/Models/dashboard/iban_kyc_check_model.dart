// To parse this JSON data, do
//
//     final ibanKycCheckModel = ibanKycCheckModelFromJson(jsonString);

import 'dart:convert';

IbanKycCheckModel ibanKycCheckModelFromJson(String str) => IbanKycCheckModel.fromJson(json.decode(str));

String ibanKycCheckModelToJson(IbanKycCheckModel data) => json.encode(data.toJson());

class IbanKycCheckModel {
  int? status;
  String? sumsubtoken;
  String? message;

  IbanKycCheckModel({
    this.status,
    this.sumsubtoken,
    this.message,
  });

  factory IbanKycCheckModel.fromJson(Map<String, dynamic> json) => IbanKycCheckModel(
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