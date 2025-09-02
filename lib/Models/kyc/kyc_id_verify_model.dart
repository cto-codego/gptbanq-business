import 'dart:convert';

KycIdVerifyModel kycIdVerifyModelFromJson(String str) =>
    KycIdVerifyModel.fromJson(json.decode(str));

String kycIdVerifyModelToJson(KycIdVerifyModel data) =>
    json.encode(data.toJson());

class KycIdVerifyModel {
  int? status;
  String? message;

  KycIdVerifyModel({
    this.status,
    this.message,
  });

  factory KycIdVerifyModel.fromJson(Map<String, dynamic> json) =>
      KycIdVerifyModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
