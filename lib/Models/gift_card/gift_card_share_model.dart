import 'dart:convert';

GiftCardShareModel giftCardShareModelFromJson(String str) =>
    GiftCardShareModel.fromJson(json.decode(str));

String giftCardShareModelToJson(GiftCardShareModel data) =>
    json.encode(data.toJson());

class GiftCardShareModel {
  int? status;
  String? message;

  GiftCardShareModel({
    this.status,
    this.message,
  });

  factory GiftCardShareModel.fromJson(Map<String, dynamic> json) =>
      GiftCardShareModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
