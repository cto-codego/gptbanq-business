import 'dart:convert';

KycFaceVerifyModel kycFaceVerifyModelFromJson(String str) =>
    KycFaceVerifyModel.fromJson(json.decode(str));

String kycFaceVerifyModelToJson(KycFaceVerifyModel data) =>
    json.encode(data.toJson());

class KycFaceVerifyModel {
  int? status;
  String? message;

  KycFaceVerifyModel({
    this.status,
    this.message,
  });

  factory KycFaceVerifyModel.fromJson(Map<String, dynamic> json) =>
      KycFaceVerifyModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
