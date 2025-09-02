import 'dart:convert';

CdgQrCodeModel cdgQrCodeModelFromJson(String str) =>
    CdgQrCodeModel.fromJson(json.decode(str));

String cdgQrCodeModelToJson(CdgQrCodeModel data) => json.encode(data.toJson());

class CdgQrCodeModel {
  final int? status;
  final String? message;
  final String? cdgId;
  final String? coin;
  final String? activateFee;

  CdgQrCodeModel({
    this.status,
    this.message,
    this.cdgId,
    this.coin,
    this.activateFee,
  });

  factory CdgQrCodeModel.fromJson(Map<String, dynamic> json) => CdgQrCodeModel(
        status: json["status"],
        message: json["message"],
        cdgId: json["cdg_id"],
        coin: json["coin"],
        activateFee: json["activate_fee"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "cdg_id": cdgId,
        "coin": coin,
        "activate_fee": activateFee,
      };
}
