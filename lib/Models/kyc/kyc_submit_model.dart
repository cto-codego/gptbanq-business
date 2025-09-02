import 'dart:convert';

KycSubmitModel kycSubmitModelFromJson(String str) =>
    KycSubmitModel.fromJson(json.decode(str));

String kycSubmitModelToJson(KycSubmitModel data) => json.encode(data.toJson());

class KycSubmitModel {
  int? status;
  String? message;

  KycSubmitModel({
    this.status,
    this.message,
  });

  factory KycSubmitModel.fromJson(Map<String, dynamic> json) => KycSubmitModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
