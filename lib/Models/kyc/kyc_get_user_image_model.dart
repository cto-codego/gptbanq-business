import 'dart:convert';

KycGetUserImageModel kycGetUserImageModelFromJson(String str) =>
    KycGetUserImageModel.fromJson(json.decode(str));

String kycGetUserImageModelToJson(KycGetUserImageModel data) =>
    json.encode(data.toJson());

class KycGetUserImageModel {
  int? status;
  String? profileimage;
  String? message;

  KycGetUserImageModel({
    this.status,
    this.profileimage,
    this.message,
  });

  factory KycGetUserImageModel.fromJson(Map<String, dynamic> json) =>
      KycGetUserImageModel(
        status: json["status"],
        profileimage: json["profileimage"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "profileimage": profileimage,
        "message": message,
      };
}
