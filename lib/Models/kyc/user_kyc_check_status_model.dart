// To parse this JSON data, do
//
//     final userKycCheckStatusModel = userKycCheckStatusModelFromJson(jsonString);

import 'dart:convert';

UserKycCheckStatusModel userKycCheckStatusModelFromJson(String str) => UserKycCheckStatusModel.fromJson(json.decode(str));

String userKycCheckStatusModelToJson(UserKycCheckStatusModel data) => json.encode(data.toJson());

class UserKycCheckStatusModel {
  int? status;
  String? message;
  int? idproof;
  int? addressproof;
  int? selfie;
  int? isSubmit;
  int? isWallet;

  UserKycCheckStatusModel({
    this.status,
    this.message,
    this.idproof,
    this.addressproof,
    this.selfie,
    this.isSubmit,
    this.isWallet,
  });

  factory UserKycCheckStatusModel.fromJson(Map<String, dynamic> json) => UserKycCheckStatusModel(
    status: json["status"],
    message: json["message"],
    idproof: json["idproof"],
    addressproof: json["addressproof"],
    selfie: json["selfie"],
    isSubmit: json["is_submit"],
    isWallet: json["is_wallet"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "idproof": idproof,
    "addressproof": addressproof,
    "selfie": selfie,
    "is_submit": isSubmit,
    "is_wallet": isWallet,
  };
}
