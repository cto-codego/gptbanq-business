import 'dart:convert';

CardTopUpConfirmModel cardTopUpConfirmModelFromJson(String str) =>
    CardTopUpConfirmModel.fromJson(json.decode(str));

String cardTopUpConfirmModelToJson(CardTopUpConfirmModel data) =>
    json.encode(data.toJson());

class CardTopUpConfirmModel {
  int? status;
  String? message;

  CardTopUpConfirmModel({
    this.status,
    this.message,
  });

  factory CardTopUpConfirmModel.fromJson(Map<String, dynamic> json) =>
      CardTopUpConfirmModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
