import 'dart:convert';

CardReplaceModel cardReplaceModelFromJson(String str) =>
    CardReplaceModel.fromJson(json.decode(str));

String cardReplaceModelToJson(CardReplaceModel data) =>
    json.encode(data.toJson());

class CardReplaceModel {
  int? status;
  String? message;

  CardReplaceModel({
    this.status,
    this.message,
  });

  factory CardReplaceModel.fromJson(Map<String, dynamic> json) =>
      CardReplaceModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
