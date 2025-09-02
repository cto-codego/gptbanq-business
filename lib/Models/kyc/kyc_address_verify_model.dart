// To parse this JSON data, do
//
//     final kycAddressVerifyModel = kycAddressVerifyModelFromJson(jsonString);

import 'dart:convert';

KycAddressVerifyModel kycAddressVerifyModelFromJson(String str) => KycAddressVerifyModel.fromJson(json.decode(str));

String kycAddressVerifyModelToJson(KycAddressVerifyModel data) => json.encode(data.toJson());

class KycAddressVerifyModel {
  int? status;
  int? isSubmitForm;
  String? message;

  KycAddressVerifyModel({
    this.status,
    this.isSubmitForm,
    this.message,
  });

  factory KycAddressVerifyModel.fromJson(Map<String, dynamic> json) => KycAddressVerifyModel(
    status: json["status"],
    isSubmitForm: json["is_submit_form"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "is_submit_form": isSubmitForm,
    "message": message,
  };
}
