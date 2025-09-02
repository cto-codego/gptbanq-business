import 'dart:convert';

BuyGiftCardConfirmModel buyGiftCardConfirmModelFromJson(String str) =>
    BuyGiftCardConfirmModel.fromJson(json.decode(str));

String buyGiftCardConfirmModelToJson(BuyGiftCardConfirmModel data) =>
    json.encode(data.toJson());

class BuyGiftCardConfirmModel {
  int? status;
  String? message;

  BuyGiftCardConfirmModel({
    this.status,
    this.message,
  });

  factory BuyGiftCardConfirmModel.fromJson(Map<String, dynamic> json) =>
      BuyGiftCardConfirmModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
