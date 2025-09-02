import 'dart:convert';

CardActiveModel cardActiveModelFromJson(String str) =>
    CardActiveModel.fromJson(json.decode(str));

String cardActiveModelToJson(CardActiveModel data) =>
    json.encode(data.toJson());

class CardActiveModel {
  int? status;
  String? message;

  CardActiveModel({
    this.status,
    this.message,
  });

  factory CardActiveModel.fromJson(Map<String, dynamic> json) =>
      CardActiveModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
