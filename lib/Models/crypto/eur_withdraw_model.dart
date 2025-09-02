// To parse this JSON data, do
//
//     final eurWithdrawModel = eurWithdrawModelFromJson(jsonString);

import 'dart:convert';

EurWithdrawModel eurWithdrawModelFromJson(String str) => EurWithdrawModel.fromJson(json.decode(str));

String eurWithdrawModelToJson(EurWithdrawModel data) => json.encode(data.toJson());

class EurWithdrawModel {
  int? status;
  String? title;
  String? body;
  String? uniqueId;
  String? message;

  EurWithdrawModel({
    this.status,
    this.title,
    this.body,
    this.uniqueId,
    this.message,
  });

  factory EurWithdrawModel.fromJson(Map<String, dynamic> json) => EurWithdrawModel(
    status: json["status"],
    title: json["title"],
    body: json["body"],
    uniqueId: json["unique_id"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "title": title,
    "body": body,
    "unique_id": uniqueId,
    "message": message,
  };
}
