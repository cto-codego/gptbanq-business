import 'dart:convert';

TrxBiometricConfirmationNotificationsModel
    trxBiometricConfirmationNotificationsModelFromJson(String str) =>
        TrxBiometricConfirmationNotificationsModel.fromJson(json.decode(str));

String trxBiometricConfirmationNotificationsModelToJson(
        TrxBiometricConfirmationNotificationsModel data) =>
    json.encode(data.toJson());

class TrxBiometricConfirmationNotificationsModel {
  int? status;
  Data? data;

  TrxBiometricConfirmationNotificationsModel({
    this.status,
    this.data,
  });

  factory TrxBiometricConfirmationNotificationsModel.fromJson(
          Map<String, dynamic> json) =>
      TrxBiometricConfirmationNotificationsModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  String? title;
  String? body;
  String? image;
  String? challengeExpiresAfter;

  Data({
    this.title,
    this.body,
    this.image,
    this.challengeExpiresAfter,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        title: json["title"],
        body: json["body"],
        image: json["image"],
        challengeExpiresAfter: json["ChallengeExpiresAfter"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
        "image": image,
        "ChallengeExpiresAfter": challengeExpiresAfter,
      };
}
