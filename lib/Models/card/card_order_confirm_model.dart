import 'dart:convert';

CardOrderConfirmModel cardOrderConfirmModelFromJson(String str) =>
    CardOrderConfirmModel.fromJson(json.decode(str));

String cardOrderConfirmModelToJson(CardOrderConfirmModel data) =>
    json.encode(data.toJson());

class CardOrderConfirmModel {
  int? status;
  String? message;

  CardOrderConfirmModel({
    this.status,
    this.message,
  });

  factory CardOrderConfirmModel.fromJson(Map<String, dynamic> json) =>
      CardOrderConfirmModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
