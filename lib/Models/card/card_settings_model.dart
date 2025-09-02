import 'dart:convert';

CardSettingsModel cardSettingsModelFromJson(String str) =>
    CardSettingsModel.fromJson(json.decode(str));

String cardSettingsModelToJson(CardSettingsModel data) =>
    json.encode(data.toJson());

class CardSettingsModel {
  int? status;
  String? message;

  CardSettingsModel({
    this.status,
    this.message,
  });

  factory CardSettingsModel.fromJson(Map<String, dynamic> json) =>
      CardSettingsModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
