import 'dart:convert';

CardBlockUnblockModel cardBlockUnblockModelFromJson(String str) =>
    CardBlockUnblockModel.fromJson(json.decode(str));

String cardBlockUnblockModelToJson(CardBlockUnblockModel data) =>
    json.encode(data.toJson());

class CardBlockUnblockModel {
  int? status;
  String? message;

  CardBlockUnblockModel({
    this.status,
    this.message,
  });

  factory CardBlockUnblockModel.fromJson(Map<String, dynamic> json) =>
      CardBlockUnblockModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
