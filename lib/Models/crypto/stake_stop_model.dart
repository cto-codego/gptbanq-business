// To parse this JSON data, do
//
//     final stakeStopModel = stakeStopModelFromJson(jsonString);

import 'dart:convert';

StakeStopModel stakeStopModelFromJson(String str) => StakeStopModel.fromJson(json.decode(str));

String stakeStopModelToJson(StakeStopModel data) => json.encode(data.toJson());

class StakeStopModel {
  int? status;
  String? message;

  StakeStopModel({
    this.status,
    this.message,
  });

  factory StakeStopModel.fromJson(Map<String, dynamic> json) => StakeStopModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
