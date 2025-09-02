import 'dart:convert';

GiftCardDeleteModel giftCardDeleteModelFromJson(String str) =>
    GiftCardDeleteModel.fromJson(json.decode(str));

String giftCardDeleteModelToJson(GiftCardDeleteModel data) =>
    json.encode(data.toJson());

class GiftCardDeleteModel {
  int? status;
  String? message;

  GiftCardDeleteModel({
    this.status,
    this.message,
  });

  factory GiftCardDeleteModel.fromJson(Map<String, dynamic> json) =>
      GiftCardDeleteModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
